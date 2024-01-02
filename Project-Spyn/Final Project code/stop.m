%code to stop the robot
brick.MoveMotor('A', 0); %stops drive motors
brick.MoveMotor('D', 0);
redraw(); %redraws GUI