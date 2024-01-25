%% Calling simulink model and security

clc
clear all

% User data (mean ± standard deviation)
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
sampled_LCW_HR = [];
sampled_LCW_RR = [];
sampled_HCW_HR = [];
sampled_HCW_RR = [];

% Generate random samples for each user and store them
for user = 1:length(LCW_HR_data)
    sampled_LCW_HR = [sampled_LCW_HR, normrnd(LCW_HR_data(user), LCW_HR_deviation(user), [1, num_samples])];
    sampled_LCW_RR = [sampled_LCW_RR, normrnd(LCW_RR_data(user), LCW_RR_deviation(user), [1, num_samples])];
    sampled_HCW_HR = [sampled_HCW_HR, normrnd(HCW_HR_data(user), HCW_HR_deviation(user), [1, num_samples])];
    sampled_HCW_RR = [sampled_HCW_RR, normrnd(HCW_RR_data(user), HCW_RR_deviation(user), [1, num_samples])];
end

% Calculate the mean and standard deviation of the sampled values
avg_user_LCW_HR = round(mean(sampled_LCW_HR));

avg_user_LCW_RR = round(mean(sampled_LCW_RR));

avg_user_HCW_HR = round(mean(sampled_HCW_HR));

avg_user_HCW_RR = round(mean(sampled_HCW_RR));

% Display the results using disp
disp('Average User Profile:');
disp(['LCW HR :: ' num2str(avg_user_LCW_HR)]);
disp(['LCW RR :: ' num2str(avg_user_LCW_RR)]);
disp(['HCW HR :: ' num2str(avg_user_HCW_HR)]);
disp(['HCW RR :: ' num2str(avg_user_HCW_RR)]);

disp(['AVERAGE HEART RATE :: ' num2str(ceil((avg_user_LCW_HR+avg_user_HCW_HR)/2))])
disp(['AVERAGE RESPIRATORY RATE :: ' num2str(ceil((avg_user_LCW_RR+avg_user_HCW_RR)/2))])

% respiratory quotient
respiratory_quotient_lcw = avg_user_LCW_HR/avg_user_LCW_RR;
reaction_time_lcw = 0.01*respiratory_quotient_lcw;
disp(['LCW REACTION_TIME :: ' num2str(reaction_time_lcw)])

respiratory_quotient_hcw = avg_user_HCW_HR/avg_user_HCW_RR;
reaction_time_hcw = 0.01*respiratory_quotient_hcw;
disp(['HCW REACTION_TIME :: ' num2str(reaction_time_hcw)])

initGain = 20000;
gainStep = 10000;
maxAllowedGain = 100000;
speedRange = 20:1:40;
decelLims = [-200, -150];

gainMap = containers.Map();

% Finding the optimal gain for non-collision
for decelLim = decelLims
   % disp(['DecelLim: ' num2str(decelLim)]);
   tempMaxGain = -inf;   % Initialize maxGain for this decelLim
   for speed = speedRange
       % disp(['Speed: ' num2str(speed)]);
       currentGain = initGain;
       % disp(['Current Gain: ' num2str(currentGain)]);
       while true
           if currentGain > maxAllowedGain
               % disp('Error: maxgain exceeded');
               break;
           end

           [A,B,C,D,Kess, Kr, Ke, uD] = designControl(secureRand(), currentGain);
           autoBraking = PREDICT_COLLISION(decelLim, speed);

           if max(autoBraking.sx1.Data) < 0
               if currentGain > tempMaxGain
                   tempMaxGain = currentGain;
               end

               break;
           else
               currentGain = currentGain + gainStep;
           end
       end
   end
   gainMap(num2str(decelLim)) = tempMaxGain;
end


% disp(gainMap.keys)
% disp(gainMap.values)

fprintf('OPTIMAL GAIN FOR NON-COLLISION :: LCW :: %d\n', gainMap(num2str(-200)))
fprintf('OPTIMAL GAIN FOR NON-COLLISION :: HCW :: %d\n', gainMap(num2str(-150)))

% Running advisory control
for decelLim = decelLims
  switch_value = 0;

  if decelLim == -200
      reaction_time = reaction_time_lcw;
  else
      reaction_time = reaction_time_hcw;
  end

  maxGain = gainMap(num2str(decelLim));

  for speed = speedRange
     [A,B,C,D,Kess, Kr, Ke, uD] = designControl(secureRand(), maxGain);
     switchCondition = ADVISORY_CONTROL(speed, decelLim, reaction_time);
     if switchCondition == "SWITCH"
        switch_value = switch_value + 1; 
     end
  end

  if decelLim == -200
      disp(['NUMBER OF SWITCHES FOR LCW ' num2str(switch_value)])
  else
      disp(['NUMBER OF SWITCHES FOR HCW ' num2str(switch_value)])
  end
end

function switchCondition = ADVISORY_CONTROL(speed, decelLim, reaction_time)

    autoBraking = PREDICT_COLLISION(decelLim, speed);

    if max(autoBraking.sx1.Data) < 0   % No collision
        switchCondition = "DO NOT SWITCH";
    else
        collision_time = max(autoBraking.sx1.Time);

        humanBraking = HUMAN_BRAKING(decelLim, speed, reaction_time);

        hStop = humanBraking.sx1.Time;
        
        if hStop < collision_time
            switchCondition = "SWITCH";
        else
            switchCondition = "DO NOT SWITCH";
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


% figure
% plot(simModel.sx1.Time,simModel.sx1.Data)
% title('Distance from the car')
% 
% figure
% plot(simModel.vx1.Time,simModel.vx1.Data)
% title('Velocity of the car')
% 
% figure
% plot(simModel.ax1.Time,simModel.ax1.Data)
% title('Deceleration of the car')




