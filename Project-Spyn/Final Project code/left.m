%code to turn the robot to the left
brick.MoveMotor('A', -20); %sets drive motors to turn right
brick.MoveMotor('D', 20);
redraw(); %redraws the GUI