%количество жертв
prey = 1;
%количество хищников
predators = 1;

%шаг
t0 = 0.01;
%время в секундах
seconds = 10;
%количество итераций(количество точек на графике)
iterations = ceil(seconds/t0);

%открытие файла для записи коэффициентов
fid = fopen('parametrs.txt','a');

%alpha не учитывается, потому как сократилась 1-ая формула (Рис 1.а)
for alpha = 1: 1: 1.0
    %beta не учитывается, потому как сократилась 1-ая формула (Рис 1.а)
    for beta = 1: 1: 1.0
        for gamma = 0.0: 0.2: 1.0
            for delta = 0.0: 0.2: 1.0
                for lambda = 0.0: 0.2: 1.0       %0 <= l <= 1
                    for rho = 0.0: 0.2: 1.0      %0 <= r <= 1
                        
                        %проверочное значение. если все значения x1 и x2 при текущих коэффициентах подходят, то test = 1
                        test = 1;
                        
                        %инициализация массивов
                        x1 = zeros(iterations);
                        x2 = zeros(iterations);
                        psi = zeros(iterations);
                        xi1 = zeros(iterations);
                        
                        c = 0.001;     %0.001 <= c <= 0.01
                        
                        % начальные значения (на 0 шаге. в матлабе с 1)
                        x1(1) = prey;
                        x2(1) = predators;
                        psi(1) = x1(1) - rho*x2(1); %по заданию разница стремится к нулю
                        xi1(1) = normrnd(0,0.1); %шум только по координате с управлениям (м.о. равно 0, с.к.о. равно 0.1)
                        
                        %вычисление значений на k = 1 шаге для некоторых формул. это
                        %связано с использованием значений k - 1 (например, x1)
                        xi1(2) = normrnd(0,0.1);
                        x1(2) = -(lambda + c)*psi(1) + rho*(x2(1) + t0*(x2(1)*(delta*x1(1) - gamma))) + t0*(xi1(2) + c*xi1(1));
                        x2(2) = x2(1) + t0*(x2(1)*(delta*x1(1) - gamma));
                        
                        for k = 2:iterations
                            xi1(k + 1) = normrnd(0,0.1); %шум только по координате с управлениям (м.о. равно 0, с.к.о. равно 0.1)
                            psi(k) = x1(k) - rho*x2(k); %по заданию разница стремится к нулю
                            x1(k + 1) = -(lambda + c)*psi(k) - c*lambda*psi(k - 1) + rho*(x2(k) + t0*(x2(k)*(delta*x1(k) - gamma))) + ...
                                t0*(xi1(k + 1) + c*xi1(k));
                            x2(k + 1) = x2(k) + t0*(x2(k)*(delta*x1(k) - gamma));
                            %отсеиваем лишние коэффициенты
                            if x1(k) > 143 || x2(k) > 143
                                test = 0;
                            end
                        end
                        %спорный момент
                        if x1(1) == x2(2)
                            check = 0;
                        end
                        
                        if test == 1
                            fprintf(fid, '%d, %d, %d, %d, %d, %d, %d\n', alpha, beta, gamma, delta, lambda, c, rho);
                        end
                    end
                end
            end
        end
    end
end
fclose(fid);