secreteNumber = randi(100);

% disp(secreteNumber) % For Test ONLY

prompt = 'Please enter a number : ';
inputNumber = input(prompt);

while inputNumber ~= secreteNumber
    
    if inputNumber > secreteNumber
    disp('Too high')
    end
    
    if inputNumber < secreteNumber
    disp('Too low')
    end
    
    prompt = 'Please guess a number : ';
    inputNumber = input(prompt);
end

disp('Correct')
disp(secreteNumber)

