import random
from datetime import datetime, timedelta
from bson import ObjectId
from data_access.mongoData import mongoData
from flask_pymongo import PyMongo
import logging
from flask import Flask, request, jsonify, json

app = Flask(__name__)
app.logger.setLevel(logging.DEBUG)

def generate_mock_data(user_id):
    if not ObjectId(user_id):
        return jsonify({'error': UserAttributeLocales.INVALID_USER_ID_FORMAT}), 400

    heart_rate = 0
    respiratory_rate = 0
    calories_burnt = 0
    steps_count = 0

    current_date = datetime.utcnow()
    timestamp = current_date.strftime("%Y-%m-%dT%H:%M:%S.000Z")

    # Rule 1: Sleep mode from 10pm to 6am
    s_sleep_time_rand = random.randrange(20, 24)
    e_sleep_time_rand = random.randrange(4, 6)

    s_random_minutes = random.randrange(0, 60)
    e_random_minutes = random.randrange(0, 60)

    sleep_start_time = datetime(current_date.year, current_date.month, current_date.day, s_sleep_time_rand, s_random_minutes)
    sleep_end_time = datetime(current_date.year, current_date.month, current_date.day, e_sleep_time_rand, e_random_minutes)
    sleep = 1 if sleep_start_time <= current_date or current_date <= sleep_end_time else 0

    # Initialize blood_oxygen outside the Gym and Jogging block
    blood_oxygen = random.randint(95, 100)

    # Rule 2: Gym and Jogging activities
    g_s_random_minutes = random.randrange(0, 60)
    g_e_random_minutes = random.randrange(0, 60)
    gym_start_time = datetime(current_date.year, current_date.month, current_date.day, 18, g_s_random_minutes)
    gym_end_time = datetime(current_date.year, current_date.month, current_date.day, 19, g_e_random_minutes)
    jogging_start_time = datetime(current_date.year, current_date.month, current_date.day, 7, g_s_random_minutes)
    jogging_end_time = datetime(current_date.year, current_date.month, current_date.day, 8, g_e_random_minutes)

    if (gym_start_time <= current_date <= gym_end_time) or \
       (jogging_start_time <= current_date <= jogging_end_time):
        # print("Setting gym and jogging data")
        heart_rate = random.randint(120, 160)
        respiratory_rate = random.randint(20, 30)
        calories_burnt = random.randint(90, 150)
        steps_count = random.randint(200, 500)
    else:
        # Rule 3: Normal heart rate and respiratory rate during sleep
        if sleep:
            # print("Setting sleep data")
            heart_rate = random.randint(60, 80)
            respiratory_rate = random.randint(12, 18)
            steps_count = 0
            calories_burnt = random.randint(10, 15)
        else:
            # Rule 10: During office hours
            office_start_time = datetime(current_date.year, current_date.month, current_date.day, 9, 0)
            office_end_time = datetime(current_date.year, current_date.month, current_date.day, 17, 0)
            # print("Setting office data")
            if office_start_time <= current_date <= office_end_time:
                # Rule 14: Random spikes during office hours (15% of the time)
                if random.random() < 0.15:
                    print("Inside spikes")
                    heart_rate = random.randint(90, 120)
                    respiratory_rate = random.randint(18, 28)
                    steps_count = random.randint(15, 30)
                    calories_burnt = random.randint(10, 20)
                else:
                    heart_rate = random.randint(70, 90)
                    respiratory_rate = random.randint(16, 22)
                    steps_count = random.randint(12, 25)
                    calories_burnt = random.randint(8, 15)
            else:
                # print("Setting normal data")
                # Rule 11: Random spikes during stressful situations
                if random.random() < 0.05:
                    heart_rate = random.randint(90, 120)
                    respiratory_rate = random.randint(18, 28)
                    steps_count = random.randint(10, 20)
                    calories_burnt = random.randint(10, 20)
                else:
                    heart_rate = random.randint(70, 90)
                    respiratory_rate = random.randint(12, 14)
                    steps_count = random.randint(8, 15)
                    calories_burnt = random.randint(8, 15)

    # Rule 12: Blood oxygen may drop slightly during intense activities
    # Rule 13: Steps count may vary based on daily routines
    blood_oxygen = random.randint(92, 98) if sleep else random.randint(95, 100)

    data = {
        "heart_rate": heart_rate,
        "respiratory_rate": respiratory_rate,
        "blood_oxygen": blood_oxygen,
        "steps_count": steps_count,
        "calories_burnt": calories_burnt,
        "sleep": sleep
    }
    mongo = mongoData(app).mongo
    user_attributes_collection = mongo.db.UserAttributes
    data['user_id'] = user_id
    data['timestamp'] = timestamp
    result = user_attributes_collection.insert_one(data)
    return result
