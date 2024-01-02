prompt = 'What is the original value? ';
x = input(prompt);
str1 = '*'; 
F = repelem([str1], [x]);
for c = 1:x
 disp(F);
 
end
