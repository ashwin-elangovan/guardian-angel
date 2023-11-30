import numpy as np
import skfuzzy as fuzz
from skfuzzy import control as ctrl

def create_fuzzy_variables():
    avg_sleep_time = ctrl.Antecedent(np.arange(0, 13, 1), 'avg_sleep_time')
    calories_burnt = ctrl.Antecedent(np.arange(0, 3001, 1), 'calories_burnt')
    preference = ctrl.Antecedent(np.arange(0, 13, 1), 'preference')
    wake_up_time = ctrl.Consequent(np.arange(240, 720, 1), 'wake_up_time')

    return avg_sleep_time, calories_burnt, preference, wake_up_time

def define_fuzzy_sets(avg_sleep_time, calories_burnt, preference, wake_up_time):
    avg_sleep_time['short'] = fuzz.trapmf(avg_sleep_time.universe, [0, 0, 3, 5])
    avg_sleep_time['moderate'] = fuzz.trimf(avg_sleep_time.universe, [3, 6, 9])
    avg_sleep_time['long'] = fuzz.trapmf(avg_sleep_time.universe, [7, 9, 12, 12])

    calories_burnt['low'] = fuzz.trimf(calories_burnt.universe, [0, 0, 1500])
    calories_burnt['moderate'] = fuzz.trimf(calories_burnt.universe, [0, 1500, 3000])
    calories_burnt['high'] = fuzz.trimf(calories_burnt.universe, [1500, 3000, 3000])

    preference['early'] = fuzz.trimf(preference.universe, [0, 0, 5])
    preference['normal'] = fuzz.trimf(preference.universe, [4, 6, 8])
    preference['late'] = fuzz.trimf(preference.universe, [7, 12, 12])

    wake_up_time['very_early'] = fuzz.trimf(wake_up_time.universe, [240, 300, 360])  # 4 to 5 hours
    wake_up_time['early'] = fuzz.trimf(wake_up_time.universe, [330, 390, 450])  # 5.5 to 6.5 hours
    wake_up_time['normal'] = fuzz.trimf(wake_up_time.universe, [390, 480, 540])  # 6.5 to 8 hours
    wake_up_time['late'] = fuzz.trimf(wake_up_time.universe, [480, 600, 720])  # 8 to 11 hours

def create_fuzzy_rules(avg_sleep_time, calories_burnt, preference, wake_up_time):
    rules = []

    # Rule 1
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['short'] & calories_burnt['low'] &
            preference['early']
        ),
        consequent=wake_up_time['early']
    ))

    # Rule 2
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['short'] & calories_burnt['low'] &
            preference['normal']
        ),
        consequent=wake_up_time['normal']
    ))

    # Rule 3
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['short'] & calories_burnt['low'] &
            preference['late']
        ),
        consequent=wake_up_time['late']
    ))

    # Rule 4
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['short'] & calories_burnt['moderate'] &
            preference['early']
        ),
        consequent=wake_up_time['early']
    ))

    # Rule 5
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['short'] & calories_burnt['moderate'] &
            preference['normal']
        ),
        consequent=wake_up_time['normal']
    ))

    # Rule 6
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['short'] & calories_burnt['moderate'] &
            preference['late']
        ),
        consequent=wake_up_time['late']
    ))

    # Rule 7
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['short'] & calories_burnt['high'] &
            preference['early']
        ),
        consequent=wake_up_time['normal']
    ))

    # Rule 8
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['short'] & calories_burnt['high'] &
            preference['normal']
        ),
        consequent=wake_up_time['late']
    ))

    # Rule 9
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['short'] & calories_burnt['high'] &
            preference['late']
        ),
        consequent=wake_up_time['early']
    ))

    # Rule 10
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['moderate'] & calories_burnt['low'] &
            preference['early']
        ),
        consequent=wake_up_time['early']
    ))

    # Rule 11
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['moderate'] & calories_burnt['low'] &
            preference['normal']
        ),
        consequent=wake_up_time['normal']
    ))

    # Rule 12
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['moderate'] & calories_burnt['low'] &
            preference['late']
        ),
        consequent=wake_up_time['late']
    ))

    # Rule 13
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['moderate'] & calories_burnt['moderate'] &
            preference['early']
        ),
        consequent=wake_up_time['normal']
    ))

    # Rule 14
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['moderate'] & calories_burnt['moderate'] &
            preference['normal']
        ),
        consequent=wake_up_time['normal']
    ))

    # Rule 15
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['moderate'] & calories_burnt['moderate'] &
            preference['late']
        ),
        consequent=wake_up_time['late']
    ))

    # Rule 16
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['moderate'] & calories_burnt['high'] &
            preference['early']
        ),
        consequent=wake_up_time['normal']
    ))

    # Rule 17
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['moderate'] & calories_burnt['high'] &
            preference['normal']
        ),
        consequent=wake_up_time['normal']
    ))

    # Rule 18
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['moderate'] & calories_burnt['high'] &
            preference['late']
        ),
        consequent=wake_up_time['late']
    ))

    # Rule 19
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['long'] & calories_burnt['low'] &
            preference['early']
        ),
        consequent=wake_up_time['very_early']
    ))

    # Rule 20
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['long'] & calories_burnt['low'] &
            preference['normal']
        ),
        consequent=wake_up_time['early']
    ))

    # Rule 21
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['long'] & calories_burnt['low'] &
            preference['late']
        ),
        consequent=wake_up_time['normal']
    ))

    # Rule 22
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['long'] & calories_burnt['moderate'] &
            preference['early']
        ),
        consequent=wake_up_time['very_early']
    ))

    # Rule 23
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['long'] & calories_burnt['moderate'] &
            preference['normal']
        ),
        consequent=wake_up_time['early']
    ))

    # Rule 24
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['long'] & calories_burnt['moderate'] &
            preference['late']
        ),
        consequent=wake_up_time['normal']
    ))

    # Rule 25
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['long'] & calories_burnt['high'] &
            preference['early']
        ),
        consequent=wake_up_time['early']
    ))

    # Rule 26
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['long'] & calories_burnt['high'] &
            preference['normal']
        ),
        consequent=wake_up_time['normal']
    ))

    # Rule 27
    rules.append(ctrl.Rule(
        antecedent=(
            avg_sleep_time['long'] & calories_burnt['high'] &
            preference['late']
        ),
        consequent=wake_up_time['normal']
    ))

    return rules

def create_fuzzy_system(rules):
    return ctrl.ControlSystem(rules)

def predict_wake_up_time(user_input, wake_up_time_prediction):
    # Get calories burnt and avg sleep time from mongoDB
    # Get user_input from user_attributes
    user_preference = {"early": 3, "normal": 6, "late": 9}.get(user_input, 6)

    wake_up_time_prediction.input['preference'] = user_preference
    wake_up_time_prediction.input['avg_sleep_time'] = 5
    wake_up_time_prediction.input['calories_burnt'] = 1500

    wake_up_time_prediction.compute()

    return int(wake_up_time_prediction.output['wake_up_time'])

def optimal_wake_up_time(user_id):
    avg_sleep_time, calories_burnt, preference, wake_up_time = create_fuzzy_variables()
    define_fuzzy_sets(avg_sleep_time, calories_burnt, preference, wake_up_time)

    rules = create_fuzzy_rules(avg_sleep_time, calories_burnt, preference, wake_up_time)

    wake_up_ctrl = create_fuzzy_system(rules)
    wake_up_time_prediction = ctrl.ControlSystemSimulation(wake_up_ctrl)

    user_input = "normal"  # Mock data for now (Will be changed in Project 5)
    predicted_wake_up_time = predict_wake_up_time(user_id, user_input, wake_up_time_prediction)

    print("Predicted Wake-up Time:", predicted_wake_up_time)

