from flask import Flask, request, jsonify, json
from flask_pymongo import PyMongo
from auth_middleware import token_required
from bson import ObjectId
from pymongo import IndexModel, ASCENDING
from datetime import datetime
from dateutil import parser
import requests
from bson.json_util import dumps
import os
from flasgger import Swagger
from constants import REGISTRATION_REQUIRED_FIELDS, USER_ATTRIBUTE_REQUIRED_FIELDS, USER_ATTRIBUTE_FETCH_KEYS, WEATHER_API_HOST
from locales import UserAttributeLocales, UserRegistrationLocales, RestaurantFoodLocales, WeatherLocales

app = Flask(__name__)
# swagger = Swagger(app)
swagger = Swagger(app, template_file='swagger.yml', parse=True)


# MongoDB configuration
app.config['MONGO_URI'] = 'mongodb://127.0.0.1:27017/GuardianAngel?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.0.2'
mongo = PyMongo(app)

@app.route('/')
def hello():
    return "Hello World!"

user_collection = mongo.db.users
user_collection.create_indexes([IndexModel([('email', ASCENDING)], unique=True)])

# User Registration API
@app.route('/users/register', methods=['POST'])
@token_required
def register_user():
    try:
        data = request.get_json()

        for field in REGISTRATION_REQUIRED_FIELDS:
            if field not in data:
                return jsonify({'error': UserRegistrationLocales.MISSING_REQUIRED_FIELD.format(field)}), 400

        user_id = user_collection.insert_one(data).inserted_id

        return jsonify({'message': UserRegistrationLocales.USER_REGISTERED_SUCCESSFULLY, 'user_id': str(user_id)}), 200

    except Exception as e:
        if 'duplicate key' in str(e).lower():
            return jsonify({'error': UserRegistrationLocales.EMAIL_ALREADY_REGISTERED}), 400
        return jsonify({'error': f'{UserRegistrationLocales.ERROR}: {str(e)}'}), 500

# User Attributes API
@app.route('/users/<string:user_id>/user_attributes', methods=['POST'])
@token_required
def add_user_attributes(user_id):
    try:
        try:
            ObjectId(user_id)
        except:
            return jsonify({'error': UserAttributeLocales.INVALID_USER_ID_FORMAT}), 400

        data = request.get_json()

        for field in USER_ATTRIBUTE_REQUIRED_FIELDS:
            if field not in data:
                return jsonify({'error': UserAttributeLocales.MISSING_REQUIRED_FIELD.format(field)}), 400

        try:
            data['timestamp'] = datetime.fromisoformat(data['timestamp'])
        except ValueError:
            return jsonify({'error': UserAttributeLocales.INVALID_TIMESTAMP_FORMAT}), 400

        user_attributes_collection = mongo.db.user_attributes
        data['user_id'] = ObjectId(user_id)
        user_attributes_collection.insert_one(data)

        return jsonify({'message': UserAttributeLocales.USER_ATTRIBUTES_ADDED_SUCCESSFULLY}), 200

    except Exception as e:
        return jsonify({'error': f'{UserAttributeLocales.ERROR}: {str(e)}'}), 500

# User Attributes GET API
@app.route('/users/<string:user_id>/user_attributes', methods=['GET'])
@token_required
def get_user_attributes(user_id):
    try:
        if not ObjectId.is_valid(user_id):
            return jsonify({'error': UserAttributeLocales.INVALID_USER_ID_FORMAT}), 400

        keys = request.args.get('keys', '').split(',')
        from_time = request.args.get('from', '')
        to_time = request.args.get('to', '')

        from_time, to_time = _parse_timestamps(from_time, to_time)

        if not all(key in USER_ATTRIBUTE_FETCH_KEYS for key in keys):
            return jsonify({'error': UserAttributeLocales.INVALID_KEYS}), 400

        query_filter = {
            'user_id': ObjectId(user_id),
            'timestamp': {'$gte': from_time, '$lte': to_time}
        }

        projection = {key: 1 for key in keys}
        projection['_id'] = 0

        user_attributes_collection = mongo.db.user_attributes
        results = user_attributes_collection.find(query_filter, projection)

        average_values = _calculate_average_values(keys, results)

        return jsonify(average_values), 200

    except Exception as e:
        return jsonify({'error': f'{UserAttributeLocales.ERROR}: {str(e)}'}), 500

# API endpoint to get all restaurants
@app.route('/restaurants', methods=['GET'])
@token_required
def get_restaurants():
    try:
        restaurants_collection = mongo.db.restaurants
        restaurants = list(restaurants_collection.find())

        serialized_restaurants = dumps({'restaurants': restaurants})
        deserialized_restaurants = json.loads(serialized_restaurants)

        for restaurant in deserialized_restaurants['restaurants']:
            restaurant['id'] = restaurant.pop('_id')['$oid']

        return jsonify(deserialized_restaurants), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/restaurants/<string:restaurant_id>/foods', methods=['GET'])
@token_required
def get_foods_for_restaurant(restaurant_id):
    try:
        restaurant_food_collection = mongo.db.restaurant_food
        if not ObjectId.is_valid(restaurant_id):
            return jsonify({'error': RestaurantFoodLocales.INVALID_RESTAURANT_ID_FORMAT}), 400

        foods = list(restaurant_food_collection.find({'restaurant_id': ObjectId(restaurant_id)}))

        serialized_foods = dumps({'foods': foods})
        deserialized_foods = json.loads(serialized_foods)

        for food in deserialized_foods['foods']:
            food['id'] = food.pop('_id')['$oid']
            food['restaurant_id'] = food.pop('restaurant_id')['$oid']

        return jsonify(deserialized_foods), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/weather', methods=['GET'])
@token_required
def get_weather():
    try:
        # Will be used in deployment
        api_key = os.getenv('openweathermap_api_key')
        lat = request.args.get('lat')
        lon = request.args.get('lon')
        city = request.args.get('city')

        if lat is not None and lon is not None:
            weather_api_url = f'{WEATHER_API_HOST}?lat={lat}&lon={lon}&appid={api_key}'
        elif city:
            weather_api_url = f'{WEATHER_API_HOST}?q={city}&appid={api_key}'
        else:
            return jsonify({'error': WeatherLocales.MISSING_PARAMETERS}), 400

        response = requests.get(weather_api_url)

        if response.status_code == 200:
            weather_data = response.json()
            formatted_weather = {
                'temperature': weather_data['main']['temp'],
                'description': weather_data['weather'][0]['description'],
                'humidity': weather_data['main']['humidity'],
                'wind_speed': weather_data['wind']['speed']
            }

            return jsonify({'weather': formatted_weather}), 200
        else:
            return jsonify({'error': WeatherLocales.DATA_FETCH_FAILED}), response.status_code

    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Private functions

def _parse_timestamps(from_time, to_time):
    try:
        from_time = datetime.strptime(from_time, "%Y-%m-%dT%H:%M:%SZ") if from_time else None
        to_time = datetime.strptime(to_time, "%Y-%m-%dT%H:%M:%SZ") if to_time else None
    except ValueError:
        return jsonify({'error': UserAttributeLocales.INVALID_TIMESTAMP_FORMAT}), 400
    return from_time, to_time

def _calculate_average_values(keys, results):
    average_values = {f'average_{key}': 0 for key in keys}
    count_values = {f'average_{key}': 0 for key in keys}

    for result in results:
        for key in keys:
            average_key = f'average_{key}'
            if key in result:
                average_values[average_key] += result[key]
                count_values[average_key] += 1

    for key in keys:
        average_key = f'average_{key}'
        if count_values[average_key] > 0:
            average_values[average_key] /= count_values[average_key]

    return average_values

if __name__ == '__main__':
    app.run(debug=True)
