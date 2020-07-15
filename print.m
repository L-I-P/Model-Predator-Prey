alpha = 1;
beta = 1;
gamma = 0.2;
delta = 0.3;
lambda = 0.9;
c = 0.001; %0.001 <= c <= 0.01
rho = 0.6;
prey = 1;      %жертвы
predators = 1; %хищники

t0 = 0.1;                      %шаг
seconds = 30;                  %время
iterations = ceil(seconds/t0); %итерации
time = 0:t0:seconds;

%инициализация массивов
x1 = zeros(1,iterations);
x2 = zeros(1,iterations);
psi = zeros(1,iterations);
xi1 = zeros(1,iterations);

% начальные значения (на 0 шаге. в матлабе с 1)
x1(1,1) = prey;
x2(1,1) = predators;
psi(1,1) = x1(1,1) - rho*x2(1,1); %по заданию разница стремится к нулю
xi1(1,1) = normrnd(0,0.1); %шум только по координате с управлениям (м.о. равно 0, с.к.о. равно 0.1)

%вычисление значений на k = 1 шаге для некоторых формул. это
%связано с использованием значений k - 1 (например, x1)
xi1(1,2) = normrnd(0,0.1);
x1(1,2) = -(lambda + c)*psi(1,1) + rho*(x2(1,1) + t0*(x2(1,1)*(delta*x1(1,1) - gamma))) + t0*(xi1(1,2) + c*xi1(1,1));
x2(1,2) = x2(1,1) + t0*(x2(1,1)*(delta*x1(1,1) - gamma));

for k = 2:iterations
    xi1(1,k + 1) = normrnd(0,0.1); %шум только по координате с управлениям (м.о. равно 0, с.к.о. равно 0.1)
    psi(1,k) = x1(1,k) - rho*x2(1,k); %по заданию разница стремится к нулю
    x1(1,k + 1) = -(lambda + c)*psi(1,k) - c*lambda*psi(1,k - 1) + rho*(x2(1,k) + t0*(x2(1,k)*(delta*x1(1,k) - gamma))) + ...
        t0*(xi1(1,k + 1) + c*xi1(1,k));
    x2(1,k + 1) = x2(1,k) + t0*(x2(1,k)*(delta*x1(1,k) - gamma));
end

%отрисовка рисунка 1
figure('Name','Рисунок 1');
plot(time, x1, 'r', time, x2, 'b')
animal = legend('жертвы','хищники');
xlabel('время')
ylabel('количество особей')
set(animal)
line2 = sprintf('alpha = %.1f, beta=%.1f, gamma=%.1f, delta=%.1f, lambda=%.1f, c=%.3f, rho=%.1f, t0 = %.1f',...
    alpha, beta, gamma, delta, lambda, c, rho, t0);
title(line2)
%отрисовка рисунка 2
figure('Name','Рисунок 2');
plot(x1, x2)
xlabel('жертвы')
ylabel('хищники')
title('фазовая плоскость')