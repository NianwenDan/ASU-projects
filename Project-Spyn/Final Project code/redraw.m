%this is code that redraws the GUI
dist = [brick.GyroAngle(3); Forward; Left; Right; "-----"; state]; %variables for the table
tdata = table(["Gyro";"Forward";"Left";"Right";"Color";"State"],dist,'VariableNames',{'Data','Values'}); %formatting the info for the table
uit = uitable(fig,'Data',tdata); %creating the table