if (Left > 45 )% if the left value is greater than right and 30
    state = "Left Turn";
    redraw(); %redraw the GUI
    brick.MoveMotor('A', 40); %go straight
    brick.MoveMotor('D', 40);
    pause (2);
    stop(); %stop all drive motors
    while (brick.GyroAngle(3)>= -35) %while the robot is not at a 90 degree angle left
        left(); %left turn
        redraw(); %redraw the GUI
    end
    brick.GyroCalibrate(3); %recalibrate gyro
    stop(); %stop all drive motors
    brick.GyroCalibrate(3); %recalibrate gyro
    stop(); %stop all drive motors
    brick.MoveMotor('A', 40); %go straight
    brick.MoveMotor('D', 40);
    pause (2.5);
    stop(); %stop all drive motors
    redraw(); %redraw the GUI
     %run the radar centering code
end
%right turn
if (Right > 45 ) %if the right value is greater than left and 30
    state = "Right Turn";
    redraw(); %redraw the GUI
    brick.MoveMotor('A', 40); 
    brick.MoveMotor('D', 40);
    pause (2);
    stop(); %stop all drive motors
    while (brick.GyroAngle(3)<= 85) %while the robot is not at a 90 degree angle right
        right();  %right turn
        redraw(); %redraw the GUI
    end
    stop();
    brick.GyroCalibrate(3); %recalibrate gyro
    stop(); %stop all drive motors
    brick.GyroCalibrate(3); %recalibrate gyro
    stop(); %stop all drive motors
    brick.MoveMotor('A', 40); %go straight
    brick.MoveMotor('D', 40);
    pause (2.5);
    stop(); %stop all drive motors
    redraw(); %redraw the GUI
     %run the radar centering code
end 