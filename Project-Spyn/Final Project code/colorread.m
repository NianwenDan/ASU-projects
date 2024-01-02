%this is code for reading and doing the logic for the color sensor
disp('color');
color = brick.ColorCode(4);
%this case is blue for drop off
if (color == 2)
    state = "drop off";
    colorstate = "blue"; %setting the color state to blue
    %redraw(); %redrawing the screem
    remote(); %enabling the remote
end
%this case is green for start
 
%this case is yellow for pick up
if (color == 4)
    while (color ==4)
        state = "pick up";
        colorstate = "yellow"; %setting the color state to red
        %redraw(); %redrawing the screen
        remote(); %enabling the remote
        color = brick.ColorCode(4);
    end
    radar();
    while (Forward >= 20) %getting off the red
        brick.MoveMotor('A', 50); %starting drive motor
        brick.MoveMotor('D', 50);
        radar();
        
    end
    
end 
%this case is red for stop
while (brick.ColorCode(4) == 5)
    state = "stop";
    colorstate = "red"; %setting the color state to red
    redraw(); %redrawing the screen
    color = brick.ColorCode(4); %reading the color
    stop(); %stopping the drive motors 
    pause (4.00)
    color = brick.ColorCode(4); %reading the color
    while (brick.ColorCode(4) == 5) %getting off the red
        brick.MoveMotor('A', 50); %starting drive motor
        brick.MoveMotor('D', 50);
        pause (0.1)
        stop(); %stopping drive motor
        color = brick.ColorCode(4); %reading the color
    end

end
colorstate = "-----";
%redraw();