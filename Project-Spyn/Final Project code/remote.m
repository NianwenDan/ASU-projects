global key
InitKeyboard();

color=brick.ColorCode(4);
while color == 2 || color == 4
    pause (0.1)
    switch key
        case 'uparrow'
            disp('up Arrow Pressed');
            brick.MoveMotor('A', 50); 
            brick.MoveMotor('D', 50);
        case 'downarrow'
            disp('up Arrow Pressed');
            brick.MoveMotor('A', -50); 
            brick.MoveMotor('D', -50);
        case 'leftarrow'
            disp('left Arrow Pressed');
            brick.MoveMotor('A', -20); 
            brick.MoveMotor('D', 20);
        case 'rightarrow'
            disp('right Arrow Pressed');
            brick.MoveMotor('A', 20); 
            brick.MoveMotor('D', -20);
        case 'a'
            disp('a pressed');
            brick.MoveMotor('A', -50); 
            brick.MoveMotor('D', -50);
            pause (2);
            brick.MoveMotor('A', 0); 
            brick.MoveMotor('D', 0);
            while (brick.GyroAngle(3)< 165) %while the angle is less than 75
                right(); %turn right
            end
            brick.MoveMotor('A', -50); 
            brick.MoveMotor('D', -50);
            pause (2);
            brick.MoveMotor('A', 0); 
            brick.MoveMotor('D', 0);
        case 0
            disp('No Key Pressed!');
            brick.MoveMotor('A', 0); 
            brick.MoveMotor('D', 0);
        case 'q'
            break;
    end
    color=brick.ColorCode(4);
end
brick.MoveMotor('A', 0); 
brick.MoveMotor('D', 0);
CloseKeyboard(); %closes keyboard library