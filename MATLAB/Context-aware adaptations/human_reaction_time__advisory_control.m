minSpeed = 20;
maxSpeed = 60;

% disp(initialSpeeds)

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

% Calculate the mean and standard deviation of the sampled values
u3_LCW_HR = round(mean(sampled_LCW_HR));

u3_LCW_RR = round(mean(sampled_LCW_RR));

u3_HCW_HR = round(mean(sampled_HCW_HR));

u3_HCW_RR = round(mean(sampled_HCW_RR));

% Display the results using disp
disp('User 3 Profile:');
disp(['LCW-HR: ' num2str(u3_LCW_HR)]);
disp(['LCW-RR: ' num2str(u3_LCW_RR)]);
disp(['HCW-HR: ' num2str(u3_HCW_HR)]);
disp(['HCW-RR: ' num2str(u3_HCW_RR)]);

% respiratory quotient
disp('Respiratory Quotient for User 3:');
u3_rq_lcw = u3_LCW_HR/u3_LCW_RR;
u3_rq_hcw = u3_HCW_HR/u3_HCW_RR;

u3_reaction_time_lcw = 0.01 * u3_rq_lcw;
u3_reaction_time_hcw = 0.01 * u3_rq_hcw;


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
avg_user_rq_lcw = avg_user_LCW_HR/avg_user_LCW_RR;
avg_user_rq_hcw = avg_user_HCW_HR/avg_user_HCW_RR;

avg_user_reaction_time_lcw = 0.01 * avg_user_rq_lcw;
avg_user_reaction_time_hcw = 0.01 * avg_user_rq_hcw;

normal_switch_count = 0;
poor_switch_count = 0;
collision_count = 0;
no_collision_count = 0;

speedRange = 20:1:60;
decelLims = [-200, -150];

reactionTimeSetting = 0.01;
gainRange = 20000:20000:100000;

f_collision_count_lcw = inf;
f_switch_count_lcw = inf;
f_gain_lcw = inf;

f_collision_count_hcw = inf;
f_switch_count_hcw = inf;
f_gain_hcw = inf;

for decelLim = decelLims
   disp(['DecelLim: ' num2str(decelLim)]);
   if decelLim == -200
      avg_user_reaction_time = avg_user_reaction_time_lcw;
      u3_reaction_time = u3_reaction_time_lcw;
   else
      avg_user_reaction_time = avg_user_reaction_time_hcw;
      u3_reaction_time = u3_reaction_time_hcw; 
   end
   tempMaxGain = -inf;   % Initialize maxGain for this decelLim
   for gain = gainRange
       normal_switch_count = 0;
       poor_switch_count = 0;
       collision_count = 0;
       no_collision_count = 0;
       disp(["Current gain " gain]);
        for speed = speedRange
            % disp(['Speed: ' num2str(speed)]);
            [A, B, C, D, Kess, Kr, Ke, uD] = designControl(secureRand(), gain);
            [collisionStatus, switchCondition] = ADVISORY_CONTROL(speed, decelLim, avg_user_reaction_time, u3_reaction_time);
        
             if switchCondition == "SWITCH"
                if decelLim == -200
                    normal_switch_count = normal_switch_count + 1;
                    % disp(["current normal_switch_count " normal_switch_count])
                else
                    poor_switch_count = poor_switch_count + 1;
                    % disp(["current poor_switch_count " poor_switch_count])
                end
             end
             
             if collisionStatus == "COLLISION"
                 collision_count = collision_count + 1;
             else
                 no_collision_count = no_collision_count + 1;
             end
        end
        disp(["Normal road switch count ", normal_switch_count])
        disp(["Poor road switch count ", poor_switch_count])
        disp(["Collision count ", collision_count])
        disp(["Non-collision count ", no_collision_count])
        
        total_switch_count = normal_switch_count + poor_switch_count;
        if decelLim == -200
            if collision_count <= f_collision_count_lcw
                f_collision_count_lcw = collision_count;
                if total_switch_count < f_switch_count_lcw
                    f_gain_lcw = gain;
                    f_switch_count_lcw = total_switch_count;
                end
            end
        else
            if collision_count <= f_collision_count_hcw
                f_collision_count_hcw = collision_count;
                if total_switch_count < f_switch_count_hcw
                    f_gain_hcw = gain;
                    f_switch_count_hcw = total_switch_count;
                end
            end
        end
   end
end

disp(["Collision count LCW " f_collision_count_lcw]);
disp(["SWITCH count LCW " f_switch_count_lcw]);
disp(["GAIN LCW " f_gain_lcw]);

disp(["Collision count HCW " f_collision_count_hcw]);
disp(["SWITCH count HCW " f_switch_count_hcw]);
disp(["GAIN HCW " f_gain_hcw]);

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
        
        % action_time = hStop - reaction_time;
    
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


