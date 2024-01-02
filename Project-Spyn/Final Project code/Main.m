%Main Method for the FSE Project

disp('Recalibrating'); %printing because it is starting the recalibrating prosess
GUI(); %starting up the GUI
brick.GyroCalibrate(3); %recalibrating the gyroscope
disp('Finished Recalibrating'); %printing when the gyro is done recalibrateing
flag = 1; % setting flag variable


while flag == 1
    disp('test1');
    radar(); %radar system
    turnlogic(); %turning logic
    %deadend(); %dead end logic
    colorread(); %referenceing the colorread method to read the colors
    gyro(); %referencing the gyro method
    

    
end





brick.StopAllMotors(); %stops every motor when code is done
