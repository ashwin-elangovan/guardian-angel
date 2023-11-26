from bson.objectid import ObjectId
from flask_pymongo import PyMongo
import os
from dotenv import load_dotenv

load_dotenv()

mongo = None
class mongoData:
    def __init__(self, app):
        self.app = app
        self.mongo = self.__get_mongo()

    def __get_mongo(self):
        if not self.app.config['TESTING']:
            self.app.config['MONGO_URI'] = os.getenv('DB_URI')
            # self.app.config['MONGO_URI'] = 'mongodb://127.0.0.1:27017/GuardianAngel?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.0.2'
        else:
            self.app.config['MONGO_URI'] = 'mongodb://localhost:27017/testdb?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.0.2'

        return PyMongo(self.app)

    def get_all(self):
        return self.__get_mongo().db.dataSources.find({})
