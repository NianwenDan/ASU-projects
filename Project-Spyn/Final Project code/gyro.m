%centering through the gyroscope
while brick.GyroAngle(3) > 4 || brick.GyroAngle(3) < -4 %if the robot is not strait
    state = "gyro center"; %sets the state
    redraw(); %redraws GUI
    if brick.GyroAngle(3) > 2 %if the angle is greater than 2
        brick.MoveMotor('A', -20); %turn left
        brick.MoveMotor('D', 20);  
        pause(.01);
        brick.MoveMotor('AD', 0);
        redraw(); % redraws the GUI
    end
    if brick.GyroAngle(3) < -2 %if the angle is less than -2
        brick.MoveMotor('A', 20); %turn right
        brick.MoveMotor('D', -20);  
        pause(.05);
        brick.MoveMotor('AD', 0);  
        redraw();% redraws the GUI
    end
end
straight(); %otherwise go straight