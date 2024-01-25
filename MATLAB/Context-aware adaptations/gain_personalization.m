% Task 2.1

numSteps = 100;
P = [0.6 0.4; 0.85 0.15];

mc = dtmc(P);

road_scenario = simulate(mc, numSteps);
disp('ROAD SCENARIO')
disp(road_scenario);

% Count occurrences of 1 (low cognitive) and 2 (high cognitive) in the scenario
low_cognitive_scenario_count = 0;
high_cognitive_scenario_count = 0;
for i = 1:100
   if road_scenario(i) == 1
       low_cognitive_scenario_count = low_cognitive_scenario_count + 1;
   else
       high_cognitive_scenario_count = high_cognitive_scenario_count + 1;
   end
end

disp(['NORMAL ROAD COUNT :: ' num2str(low_cognitive_scenario_count)]);
disp(['POOR ROAD COUNT :: ' num2str(high_cognitive_scenario_count)]);

minSpeed = 20;
maxSpeed = 60;


% Task 2.2
initialSpeeds = zeros(1, numSteps);

for i = 1:numSteps
    intermSpeed = minSpeed + (maxSpeed - minSpeed) * rand;
    initialSpeeds(i) = intermSpeed;
end

disp("INITIAL SPEED RANGE")
disp(initialSpeeds)

% Task 2.3
% User 3 data (mean ± standard deviation)
LCW_HR_data = [61];
LCW_HR_deviation = [14];

LCW_RR_data = [17];
LCW_RR_deviation = [8];

HCW_HR_data = [92];
HCW_HR_deviation = [23];

HCW_RR_data = [26];
HCW_RR_deviation = [16];

% Number of samples to generate for the User 3 user
num_samples = 100;

lower_limit = 1;

% Initialize arrays to store sampled values
sampled_LCW_HR = [];
sampled_LCW_RR = [];
sampled_HCW_HR = [];
sampled_HCW_RR = [];

% Generate random samples for each user and store them
for user = 1:length(LCW_HR_data)
    % Generate random samples
    LCW_HR_samples = normrnd(LCW_HR_data(user), LCW_HR_deviation(user), [1, num_samples]);
    LCW_RR_samples = normrnd(LCW_RR_data(user), LCW_RR_deviation(user), [1, num_samples]);
    HCW_HR_samples = normrnd(HCW_HR_data(user), HCW_HR_deviation(user), [1, num_samples]);
    HCW_RR_samples = normrnd(HCW_RR_data(user), HCW_RR_deviation(user), [1, num_samples]);
    
    % Append the generated samples to the respective arrays
    sampled_LCW_HR = [sampled_LCW_HR, LCW_HR_samples];
    sampled_LCW_RR = [sampled_LCW_RR, LCW_RR_samples];
    sampled_HCW_HR = [sampled_HCW_HR, HCW_HR_samples];
    sampled_HCW_RR = [sampled_HCW_RR, HCW_RR_samples];
end

% Print sampled_LCW_HR values with ceil
fprintf('Sampled LCW_HR values for User 3:\n');
for i = 1:length(sampled_LCW_HR)
    fprintf('%d ', ceil(sampled_LCW_HR(i)));
end
fprintf('\n');

% Print sampled_LCW_RR values with ceil
fprintf('Sampled LCW_RR values for User 3:\n');
for i = 1:length(sampled_LCW_RR)
    fprintf('%d ', ceil(sampled_LCW_RR(i)));
end
fprintf('\n');

% Print sampled_HCW_HR values with ceil
fprintf('Sampled HCW_HR values for User 3:\n');
for i = 1:length(sampled_HCW_HR)
    fprintf('%d ', ceil(sampled_HCW_HR(i)));
end
fprintf('\n');

% Print sampled_HCW_RR values with ceil
fprintf('Sampled HCW_RR values for User 3:\n');
for i = 1:length(sampled_HCW_RR)
    fprintf('%d ', ceil(sampled_HCW_RR(i)));
end
fprintf('\n');



% All User data (mean ± standard deviation)
LCW_HR_data = [80, 65, 61];
LCW_HR_deviation = [14, 15, 14];

LCW_RR_data = [16, 13, 17];
LCW_RR_deviation = [6, 4, 8];

HCW_HR_data = [95, 71, 92];
HCW_HR_deviation = [26, 21, 23];

HCW_RR_data = [21, 14, 26];
HCW_RR_deviation = [16, 5, 16];

% Number of samples to generate for the average user
num_samples = 50;

% Initialize arrays to store sampled values
avg_sampled_LCW_HR = [];
avg_sampled_LCW_RR = [];
avg_sampled_HCW_HR = [];
avg_sampled_HCW_RR = [];

% Generate random samples for each user and store them
for user = 1:length(LCW_HR_data)
    avg_sampled_LCW_HR = [avg_sampled_LCW_HR, normrnd(LCW_HR_data(user), LCW_HR_deviation(user), [1, num_samples])];
    avg_sampled_LCW_RR = [avg_sampled_LCW_RR, normrnd(LCW_RR_data(user), LCW_RR_deviation(user), [1, num_samples])];
    avg_sampled_HCW_HR = [avg_sampled_HCW_HR, normrnd(HCW_HR_data(user), HCW_HR_deviation(user), [1, num_samples])];
    avg_sampled_HCW_RR = [avg_sampled_HCW_RR, normrnd(HCW_RR_data(user), HCW_RR_deviation(user), [1, num_samples])];
end

% Calculate the mean and standard deviation of the sampled values
avg_user_LCW_HR = round(mean(avg_sampled_LCW_HR));

avg_user_LCW_RR = round(mean(avg_sampled_LCW_RR));

avg_user_HCW_HR = round(mean(avg_sampled_HCW_HR));

avg_user_HCW_RR = round(mean(avg_sampled_HCW_RR));

% Display the results using disp
disp('Average User Profile:');
disp(['LCW-HR: ' num2str(avg_user_LCW_HR)]);
disp(['LCW-RR: ' num2str(avg_user_LCW_RR)]);
disp(['HCW-HR: ' num2str(avg_user_HCW_HR)]);
disp(['HCW-RR: ' num2str(avg_user_HCW_RR)]);

% respiratory quotient
respiratory_quotient_lcw = avg_user_LCW_HR/avg_user_LCW_RR;
respiratory_quotient_hcw = avg_user_HCW_HR/avg_user_HCW_RR;

% From Task 1
gain_for_poor_road = 90000;
gain_for_normal_road = 100000;

normal_switch_count = 0;
poor_switch_count = 0;
collision_count = 0;
no_collision_count = 0;

switch_array = zeros(1, numSteps);
collision_array = zeros(1, numSteps);

% Task 2.4 and Task 2.5
for i = 1:numSteps  % Use '1:numSteps' to loop through from 1 to numSteps
    if road_scenario(i) == 1
        gain = gain_for_normal_road;
        avg_HR = ceil(sampled_LCW_HR(i));
        avg_RR = ceil(sampled_LCW_RR(i));
        respiratory_quotient = avg_HR / avg_RR;
        u3_reaction_time = 0.01 * respiratory_quotient;
        avg_user_reaction_time_lcw = 0.01 * respiratory_quotient_lcw;
        avg_user_reaction_time = avg_user_reaction_time_lcw;
        decelLim = -200;
    else
        gain = gain_for_poor_road;
        avg_HR = ceil(sampled_HCW_HR(i));
        avg_RR = ceil(sampled_HCW_RR(i));
        respiratory_quotient = avg_HR / avg_RR;
        u3_reaction_time = 0.01 * respiratory_quotient;
        avg_user_reaction_time_hcw = 0.01 * respiratory_quotient_hcw;
        avg_user_reaction_time = avg_user_reaction_time_hcw;
        decelLim = -150;
    end

    [A, B, C, D, Kess, Kr, Ke, uD] = designControl(secureRand(), gain);
    disp(["Current speed " initialSpeeds(i) i])
    [collisionStatus, switchCondition] = ADVISORY_CONTROL(initialSpeeds(i), decelLim, avg_user_reaction_time, u3_reaction_time);

     if switchCondition == "SWITCH"
        switch_array(i) = 1;
        if road_scenario(i) == 1
            normal_switch_count = normal_switch_count + 1;
            % disp(["current normal_switch_count " normal_switch_count])
        else
            poor_switch_count = poor_switch_count + 1;
            % disp(["current poor_switch_count " poor_switch_count])
        end
     end

     if collisionStatus == "COLLISION"
         collision_array(i) = 1;
         collision_count = collision_count + 1;
         % disp("Collision Count added");
     else
         no_collision_count = no_collision_count + 1;
     end
end

disp(["Collision count " collision_count])
disp(["NORMAL ROAD Switch count " normal_switch_count])
disp(["POOR ROAD Switch count " poor_switch_count])
disp(["Total switch count " normal_switch_count + poor_switch_count]);

fprintf('Switch Array:\n');
fprintf('%d ', switch_array);
fprintf('\n');

fprintf('Collision Array:\n');
fprintf('%d ', collision_array);
fprintf('\n');

% Task 2.6

startRFValue = 0.01;
endRFValue = 0.02;
stepSize = 0.01;
rfRange = startRFValue:stepSize:endRFValue;

f_collision_count = inf;
f_switch_count = inf;
f_reaction_time_setting = 0.01;

for rf = rfRange
    normal_switch_count = 0;
    poor_switch_count = 0;
    collision_count = 0;
    no_collision_count = 0;

    for i = 1:numSteps  % Use '1:numSteps' to loop through from 1 to numSteps
        if road_scenario(i) == 1
            gain = gain_for_normal_road;
            avg_HR = ceil(sampled_LCW_HR(i));
            avg_RR = ceil(sampled_LCW_RR(i));
            respiratory_quotient = avg_HR / avg_RR;
            u3_reaction_time = 0.01 * respiratory_quotient;
            avg_user_reaction_time_lcw = rf * respiratory_quotient_lcw;
            avg_user_reaction_time = avg_user_reaction_time_lcw;
            decelLim = -200;
        else
            gain = gain_for_poor_road;
            avg_HR = ceil(sampled_HCW_HR(i));
            avg_RR = ceil(sampled_HCW_RR(i));
            respiratory_quotient = avg_HR / avg_RR;
            u3_reaction_time = 0.01 * respiratory_quotient;
            avg_user_reaction_time_hcw = rf * respiratory_quotient_hcw;
            avg_user_reaction_time = avg_user_reaction_time_hcw;
            decelLim = -150;
        end

        [A, B, C, D, Kess, Kr, Ke, uD] = designControl(secureRand(), gain);
        % disp(["Current speed " initialSpeeds(i) i])
        [collisionStatus, switchCondition] = ADVISORY_CONTROL(initialSpeeds(i), decelLim, avg_user_reaction_time, u3_reaction_time);

         if switchCondition == "SWITCH"
            if road_scenario(i) == 1
                normal_switch_count = normal_switch_count + 1;
                % disp(["current normal_switch_count " normal_switch_count])
            else
                poor_switch_count = poor_switch_count + 1;
                % disp(["current poor_switch_count " poor_switch_count])
            end
         end

         if collisionStatus == "COLLISION"
             collision_count = collision_count + 1;
             disp("Collision Count added");
         else
             no_collision_count = no_collision_count + 1;
         end
    end
    disp(["RF ", rf])
    disp(["Normal road switch count ", normal_switch_count])
    disp(["Poor road switch count ", poor_switch_count])
    disp(["Collision count ", collision_count])
    disp(["Non-collision count ", no_collision_count])
    total_switch_count = normal_switch_count + poor_switch_count;
    if collision_count < f_collision_count
        f_collision_count = collision_count;
        f_reaction_time_setting = rf;
        if total_switch_count < f_switch_count
            f_switch_count = total_switch_count;
        end
    end
end

disp(["FINAL Collision count " f_collision_count])
disp(["FINAL Reaction time setting " f_reaction_time_setting])
disp(["FINAL Switch count " f_switch_count])


function [collisionStatus, switchCondition] = ADVISORY_CONTROL(speed, decelLim, avg_user_reaction_time, u3_reaction_time)
    autoBraking = PREDICT_COLLISION(decelLim, speed);
    if max(autoBraking.sx1.Data) < 0
        % No collision as AB braking system can handle
        % No collision no switch
        switchCondition = "NO SWITCH";
        collisionStatus = "NO COLLISION";
    else 
        % Collision Happens
        collision_time = max(autoBraking.sx1.Time);
        
        humanBraking = HUMAN_BRAKING(decelLim, speed, avg_user_reaction_time);
        
        hStop = humanBraking.sx1.Time;
    
        if hStop < collision_time 
            % Average human can handle the case
            humanBraking = HUMAN_BRAKING(decelLim, speed, u3_reaction_time);
            u3hStop = humanBraking.sx1.Time;
            if u3hStop < collision_time 
                % User3 can handle the case
                switchCondition = "SWITCH";
                collisionStatus = "NO COLLISION";
            else
                switchCondition = "SWITCH";
                collisionStatus = "COLLISION";
            end
        else 
            % Human cannot handle. Will collide anyways.
            % Crash and No switch
            switchCondition = "NO SWITCH";
            collisionStatus = "COLLISION";
        end
    end
end

function autoBraking = PREDICT_COLLISION(decelLim, speed)
    open_system('LaneMaintainSystem.slx');
    set_param('LaneMaintainSystem/VehicleKinematics/Saturation', 'LowerLimit', num2str(decelLim));
    set_param('LaneMaintainSystem/VehicleKinematics/vx', 'InitialCondition', num2str(speed));
    autoBraking = sim('LaneMaintainSystem.slx'); 
end

function humanBraking = HUMAN_BRAKING(decelLim, speed, reaction_time)
    open_system('HumanActionModel.slx');
    set_param('HumanActionModel/Step', 'Time', num2str(reaction_time));
    set_param('HumanActionModel/Step', 'Before', '0');
    set_param('HumanActionModel/Step', 'After', num2str(1.1*decelLim));
    set_param('HumanActionModel/VehicleKinematics/vx', 'InitialCondition', num2str(speed));
    humanBraking = sim('HumanActionModel.slx');
end


