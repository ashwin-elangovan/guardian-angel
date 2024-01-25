# Guardian-Angel
Guardian Angel is an innovative multifaceted Android application integrated with MATLAB which is designed for the following
1) To control autonomous vehicles by taking into all the relative factors
2) To enhance the well-being and safety of users by monitoring and providing personalized suggestions for various aspects of their daily lives.
3) To real-time data, including vital signs, location, and weather conditions to deliver timely and tailored recommendations.

## Autonomous vehicle braking system

### Context-Aware Adaptation
The project focuses on developing a context-aware adaptation strategy for the autonomous braking system of Level 3 autonomous cars. This involves designing a controller that adjusts braking pressure based on various factors such as vehicle speed, distance between cars, and environmental conditions, while ensuring safety limits are not exceeded. The system incorporates a feedback loop controller and accounts for human intervention in case of potential collisions. Additionally, it considers human factors such as reaction time and workload based on driving context. The project is divided into three tasks: designing the advisory control for an average user, modifying it for a specific user, and finally, refining it based on data collected during deployment to personalize it for specific user profiles. This iterative approach mirrors standard context-aware application development workflows in the automotive industry.

### Location-based Perception and Action in Guardian Angel for Autonomous Driving

#### Phase 1:
In this phase, Google services are integrated into the existing autonomous driving application to monitor real-time traffic conditions along the route. A new activity in the app allows users to input their starting and destination addresses, which then retrieves the route information using the Google Maps API. Traffic congestion data is obtained along the path and analyzed using a clustering algorithm to categorize road conditions into normal or poor, determining the cognitive workload accordingly.

#### Phase 2:
Phase 2 involves designing a fuzzy logic-based advisory control system for autonomous braking in a Vehicular Ad Hoc Network (VANET). Car B's autonomous braking system must react to the deceleration of Car A, which is unknown. The advisory control system estimates Car A's braking force, the distance between the vehicles, and the road condition obtained from Task 1 to determine Car B's deceleration. A switching rule determines whether Car B should switch to human control based on the calculated deceleration.

## Health Monitoring System

The Guardian Angel Health Monitoring System is a comprehensive feature designed to continuously monitor vital signs, including heart rate, respiratory rate, and step count. This system provides valuable insights into the user's overall well-being, promptly detecting irregularities or concerning trends. In critical situations, the app prompts the user to seek medical attention and has the capability to notify emergency contacts.

## Components

### 1. Android App

The Android app serves as the user interface, facilitating interaction and displaying relevant information. It utilizes various sensors to gather data on heart rate, respiratory rate, and step counts. The collected data is stored in a hosted database for further analysis.

#### Steps to Run Android Code:

1. Install Android Studio from [Download Android Studio](https://developer.android.com/studio#get-android-studio)
2. Open the project in Android Studio
3. Run the app on an emulator for better performance
4. Check if notification permission is given for the app. If not, kindly give the permission.

#### Instructions to run in android phone:
An APK is attached. Follow the steps to see the suggestions:
1. Install the APK.
2. Start and allow the permissions
3. Wait for the app to see the current user's location
4. The suggested item would be displayed in the box below

#### Notes:
1. The app is designed to work on Android 10 and above
2. Kindly maintain a good internet connection since a poor internet connection can cause the HTTP requests to timeout

### 2. Backend Implementation (Python)

The backend, implemented in Python, plays a crucial role in processing the sensor data. The data undergoes analysis using fuzzy logic inference rules to diagnose the user's health condition. The fuzzy logic API is hosted on Heroku, providing an accessible endpoint for the Android app to retrieve the diagnosis.

#### Steps to run python code
1. Use Python 3.11
2. Run `pip install -r requirements.txt`
3. Create a `.env` file in the root directory and add the following variables:
    ```env
    DB_URI=mongodb+srv://<mongo_url>/Guardian-Angel?retryWrites=true&w=majority
    TEST_DB_URI=mongodb://127.0.0.1:27017/testdb?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.0.2
    DB_NAME=GuardianAngel
    ```
To test the production DB using mongo_url, kindly reach out to [ashelangovan@gmail.com](ashelangovan@gmail.com)

4. Run `python3 -u "<path to directory>/main.py"`
5. To run tests, run the following command:
    ```bash
    export auth_verification_key=test
    python -m unittest -vv tests.user
    python -m unittest -vv tests.restaurant
    python -m unittest -vv tests.weather
    ```

The python flask server is hosted on Heroku and can be accessed using the following link: [Guardian Angel Heroku](https://mc-guardian-angel-1fec5a1eb0b8.herokuapp.com/)

I've written Swagger docs for the following APIs, which can be accessed [here](https://mc-guardian-angel-1fec5a1eb0b8.herokuapp.com/apidocs/).

### 3) Backend implementation (MATLAB)
The MATLAB implementation serves as a critical component in processing sensor data collected by the Android app. It focuses on analyzing health-related data using fuzzy logic inference rules to provide insights into the user's health condition. Additionally, MATLAB plays a role in data visualization and further analysis, contributing to a comprehensive health monitoring system.

#### Steps to Run MATLAB Code:

1) Ensure MATLAB is installed on your system.
2) Open the MATLAB project in the MATLAB software environment.
3) Run the MATLAB scripts inside the MATLAB folder for data analysis and visualization.

## User Flow

1. **Home Page:**
   - The app features a home page with a "Get Updates" button.
   - Clicking the button triggers the backend implementation.

2. **Diagnosis Page:**
   - After processing, the user is directed to a new page displaying the diagnosis.
   - Notifications are sent to ensure the user receives the message.

3. **Navigation:**
   - A "Back" button on the diagnosis page allows users to return to the home page.

## Components

1. **Data Collection:**
   - Sensors on the Android device collect heart rate, respiratory rate, and step count data.

2. **Database Storage:**
   - The collected data is stored in a hosted database.

3. **Backend Analysis:**
   - The Python backend uses fuzzy logic inference rules to analyze the sensor data.

4. **Diagnosis Retrieval:**
   - The Android app calls the hosted fuzzy logic API on Heroku to retrieve the user's diagnosis.

5. **User Notification:**
   - Notifications are sent to the user to ensure timely awareness of their health status.

## Features

### 1. Emergency Contacts

The app securely stores emergency contact information. In critical situations, the system can initiate contact with the designated emergency contacts.
This Health Monitoring System aims to proactively manage user health, offering a comprehensive solution for continuous well-being assessment.

### 2. Dietary Guidance
This feature takes health and diet preferences into its functionality and takes a proactive approach to constantly monitor user activity, especially when at a restaurant, the app provides tailored food suggestions aligned with the user's health and diet preferences.

### 3. Smart Alarm

The app monitors sleep patterns, helping users achieve a better night's rest. If a user hasn't slept enough, Guardian Angel provides tips for improving sleep quality and duration, also sets an alarm for an appropriate waking-up time.

The scheduler will run at 9 pm (configurable based on the user's sleep pattern) every day and set the alarm usually 5-9 hours later. This will be totally in the background which can be observed in the logs. Only the alarm will be visible to the users

### 4. Weather recommendation
The app takes into account the local weather conditions and provides pertinent suggestions (Weather API), such as carrying an umbrella in case of rain, applying sunscreen in high UV index situations, or dressing appropriately for extreme temperatures.

*Currently the suggestions would be the same as dummy hardcoded values are being used, once the feature is integrated with other components it will work as expected.
