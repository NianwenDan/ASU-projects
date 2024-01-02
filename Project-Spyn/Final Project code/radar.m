state = "radar"; %declares the state
redraw(); %redraws the GUI
%right
disp('right');
colorread();
brick.MoveMotor('B', -40); %turns Right
while(~brick.TouchPressed(2))
    colorread();
end
brick.MoveMotor('B', 0); 
pause (.07);
readright(); %reads the ultrasonic sensor value
%front
disp('front');
colorread();
brick.MoveMotor('B', 20); %setting the sensor to be straight
pause (.15);
brick.MoveMotor('B', 0); 
pause (.1);
readforward();%reads the ultrasonic sensor value
colorread();
%left
disp('left');
colorread();
brick.MoveMotor('B', 50); %turning the sensor left
while(~brick.TouchPressed(2))
    colorread();
end
brick.MoveMotor('B', 0); 
pause (.1);
readleft(); %reads the ultrasonic sensor value
%reset
disp('reset');
colorread();
brick.MoveMotor('B', -20); %turning the sensor to original possition
pause (.05);
brick.MoveMotor('B', 0); 
pause (.1);
Correct = ((Left + Right)/2)-3; %correct distance calculation
%disp('Correct: ' + (Left + Right));