%code that is for the condition of a dead end 
if (Forward < 25 && color ~= 2 && color ~= 3 && color ~= 4 && color ~= 5 && Left < 30 && Right < 30)%if it hits a dead end
    radar(); %turn on radar
    while (brick.GyroAngle(3)< 80) %while the angle is less than 75
        right(); %turn right
    end
    brick.GyroCalibrate(3); %calabrate gyro
    stop(); %stop drive motors
    brick.GyroCalibrate(3); %calabrate gyro
    while (Left < 30 || Right < 30)  %while the left or right are less than 30 to search for an area to turn
        if (Forward < 10)
            break;
        end    
        straight(); %goes strait
        radar(); %turns on radar
    end
    stop(); %stops drive motors
    while (Left > 30 || Right > 30)  %while eather side is greater than 30 
        if (Forward < 10)
            break;
        end   
        straight(); %drives straigt 
        radar(); %turns on radar
    end
    stop(); %stops drive motors
    
    
end