promptA = 'Enter number A: ';
numA = input(promptA);
promptB = 'Enter number B: ';
numB = input(promptB);

if  numA < 0 || numB < 0 
    disp('Both numbers must over than 0')
end

if numA >= 0 && numB >=0
    minValue = min(min(numA, numB));
    %disp(minValue)
    evenNum = 0;
    disp(evenNum);
    if mod(minValue,2) == 0
        while evenNum < minValue
            evenNum = evenNum + 2;
            disp(evenNum)
        end
    else 
        minValue = minValue - 1;
        while evenNum < minValue
            evenNum = evenNum + 2;
            disp(evenNum)
        end
    end
end
