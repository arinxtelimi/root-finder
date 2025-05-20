clc; clear;
func1 = @(x) x*exp(-x) - 2*x + 1;           Int1.a = 0;     Int1.b = 3;
func2 = @(x) x*cos(x) - 2*x^2 + 3*x - 1;    Int2.a = 1;     Int2.b = 3;
func3 = @(x) x^3-7*x^2+14*x-6;              Int3.a = 0;     Int3.b = 1;
func4 = @(x) sqrt(x)-cos(x);                Int4.a = 0;     Int4.b = 1;
func5 = @(x) 2*x*cos(2*x) - (x+1)^2;        Int5.a = -4;    Int5.b = -2;
func6 = @(x) x^3 - 32*x + 128;              Int6.a = -8;    Int6.b = 0;
func7 = @(x) x^4 -2*x^3-4*x^2+4*x+4;        Int7.a = 0;     Int7.b = 2;
func8 = @(x) -x^3 - cos(x);                 Int8.a = -3;    Int8.b = 3;
func9 = @(x) (x-5)^7 - 1e-1;                Int9.a = 0;     Int9.b = 10; 
func10 = @(x) (x-3)^11;                     Int10.a = 2.4;  Int10.b = 3.4; 

test_functions = {func1, func2, func3, func4, func5, func6, func7, func8, func9, func10};
test_intervals = {Int1, Int2, Int3, Int4, Int5, Int6, Int7, Int8, Int9, Int10};

params.root_tol = 1e-7; params.func_tol = 1e-7;

fprintf('%-5s %-20s %-15s %-15s\n', 'Test', 'Function', 'Root', 'Function Calls');
fprintf('-------------------------------------------------\n');

for j = 1:length(test_functions)
    func = test_functions{j}; 
    Int = test_intervals{j};
    
    profile on;
    [root, info] = modifiedzeroinn(func, Int, params);
    profile off;
    
    % Get number of function calls
    p = profile('info');
    foo = {p.FunctionTable.FunctionName};
    bar = strfind(foo, func2str(func));
    fcall_idx = find(~cellfun(@isempty, bar));
    num_fcall = sum([p.FunctionTable(fcall_idx).NumCalls]);
    
    % Display results
    fprintf('%-5d %-20s %-15.8f %-15d\n', ...
            j, func2str(func), root, num_fcall);
end