function [root, info] = modifiedzeroinn(func, Int, params)    
    a = Int.a;
    b = Int.b;
    fa = func(a);
    fb = func(b);   

    if fa * fb >= 0
        root = NaN;
        info.flag = 1;
        info.message = 'Function must have opposite signs at interval endpoints';
        return;
    end
    
    info.flag = 0;
    
    % Sort a and b 
    if abs(fa) > abs(fb)
        [a, b] = deal(b, a);
        [fa, fb] = deal(fb, fa);
    end
    
    % Set c as midpoint
    c = (a + b) / 2;
    fc = func(c);
    
    % IQI performance
    last_four_values = Inf(1, 4);
    bisection_needed = false;
    
    func_evals = 3;
    
    % Main loop
    while true
        if abs(fc) < params.func_tol
            root = c;
            info.func_evals = func_evals;
            return;
        end
        if abs(b - a) < params.root_tol
            root = c;
            info.func_evals = func_evals;
            return;
        end
        
        % Do bisection if necessary
        if bisection_needed || abs(fa - fc) < eps || abs(fb - fc) < eps
            bisection_needed = false;     
            prev_c = c;
            c = (a + b) / 2;
            fc = func(c);
            func_evals = func_evals + 1;       
            if fa * fc < 0
                b = c;
                fb = fc;
            else
                a = c;
                fa = fc;
            end   
            if abs(fa) > abs(fb)
                [a, b] = deal(b, a);
                [fa, fb] = deal(fb, fa);
            end
            
            % Update points for next IQI
            c = (a + b) / 2;
            fc = func(c);
            func_evals = func_evals + 1;
            
            last_four_values = Inf(1, 4);
        else
            % Try IQI
            denominator1 = (fa - fb) * (fa - fc);
            denominator2 = (fb - fa) * (fb - fc);
            denominator3 = (fc - fa) * (fc - fb);
            
            if abs(denominator1) < eps || abs(denominator2) < eps || abs(denominator3) < eps
                % USe bisection if denominators are too small
                bisection_needed = true;
                continue;
            end
            
            term1 = (fb * fc / denominator1) * a;
            term2 = (fa * fc / denominator2) * b;
            term3 = (fa * fb / denominator3) * c;  
            next_x = term1 + term2 + term3;
            
            % Check if is in the interval
            if next_x < a || next_x > b
                bisection_needed = true;
                continue;
            end
            
            % Evaluate function at the point found from the IQI
            fnext = func(next_x);
            func_evals = func_evals + 1;
            
            % Update last four values
            last_four_values = [last_four_values(2:4), abs(fnext)];
            
            % Check convergence rate
            if all(~isinf(last_four_values)) && last_four_values(4) > last_four_values(1) / 2
                bisection_needed = true;
                continue;
            end
            
            if fa * fnext < 0
                b = next_x;
                fb = fnext;
            else
                a = next_x;
                fa = fnext;
            end
            
            % Update IQI
            if abs(fa) < abs(fb)
                c = a;
                fc = fa;
            else
                c = b;
                fc = fb;
            end
            
            % Check convergence
            if abs(fc) < params.func_tol
                root = c;
                info.func_evals = func_evals;
                return;
            end
        end
    end
end