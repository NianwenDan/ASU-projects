%code to center the robot using radar()

%Left is greater than right side
if ((Left-3)>= Right)&& (60 > Left) %checking to ensure that the left side is greater than the right and 60 cm
    state = "center"; %setting the state
    redraw(); %redrawing the screen
    while (brick.GyroAngle(3)> -40) %continue turning until the robot has hit a 40 degree angle
        left(); %left turn values
    end
    stop(); %stops drive motors
    pause (.01)
    brick.MoveMotor('B', 20); %sets the radar to be in the correct possition
    pause (.3)
    brick.MoveMotor('B', 0);
    %pause (.1);
    readforward(); %reads radar value
    while(Forward>=Correct)
        straight(); %sets the drive motors to go straight
        readforward(); %reads radar value
    end     
    stop(); %stops drive motors 
    pause (.01)
    brick.MoveMotor('B', -20);%resets the radar to be in the correct possition
    pause (.18)
    brick.MoveMotor('B', 0);
    %pause (.1);
    while (brick.GyroAngle(3)< -5) %fixes the angle
        right(); %right turn values
    end
    brick.GyroCalibrate(3); %recalibrates the gyro
end

%Right is greater than left side
if ((Right-3)>= Left)&& (60 > Right) %checking to ensure that the left side is greater than the right and 60 cm
    state = "center"; %setting the state
    redraw();%redrawing the screen
    while (brick.GyroAngle(3)< 40) %continue turning until the robot has hit a 40 degree angle
        right(); %right turn values
    end
    stop();
    pause (.01)
    brick.MoveMotor('B', -20); %sets the radar to be in the correct possition
    pause (.3)
    brick.MoveMotor('B', 0);
    readforward(); %reads radar value
    %pause (.1);
    while(Forward>=Correct)    
        straight(); %sets the drive motors to go straight
        readforward(); %reads radar value
    end
    stop(); %stops drive motors 
    pause (.01)
    brick.MoveMotor('B', 20); %resets the radar to be in the correct possition
    pause (.18)
    brick.MoveMotor('B', 0);
    %pause (.1);
    while (brick.GyroAngle(3)> 5) %fixes the angle
        left(); %left turn values
    end
    brick.GyroCalibrate(3); %recalibrates the gyro
end 

straight();
if key == 'a'
    flag = 0;
end
%end
%brick.StopAllMotors();
%CloseKeyboard();