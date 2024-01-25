function [switchValue, timeOfSwitch] = AshwinElangovan(velocityA, distanceBtnAB)
    decelLim = -200; % Define deceleration limit
    time_step = 0.01; % Define your time step

    num_samples = length(velocityA);
    decelerationA = zeros(1, num_samples);

    speed_difference = 1.72; % speed difference got from android app

    for i = 2:num_samples
        decelerationA(i) = (velocityA(i) - velocityA(i-1)) / time_step;
    end

    fis = readfis('AshwinElangovan.fis');
    
    for i = 1:length(velocityA)
        decelA = abs(decelerationA(i));
        distanceAB = distanceBtnAB(i);

        inputVector = [decelA, distanceAB, speed_difference];
        decelerationB = evalfis(fis, inputVector);
        % disp(['decelA: ', num2str(decelA), '  distanceAB: ', num2str(distanceAB), '  speed_difference: ', num2str(speed_difference), ' DECELB: ', num2str(decelerationB)]);
        if abs(decelerationB) > 0.75 * abs(decelLim)
            switchValue = 1;
            timeOfSwitch = num2str(i * time_step);
            return;
        end
    end

    % If no switch condition is met, set switchValue to 0 and timeOfSwitch to 'NA'
    switchValue = 0;
    timeOfSwitch = 'NA';
end