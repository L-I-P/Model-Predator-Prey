alpha = 1;
beta = 1;
gamma = 0.2;
delta = 0.3;
lambda = 0.9;
c = 0.001; %0.001 <= c <= 0.01
rho = 0.6;
prey = 1;      %������
predators = 1; %�������

t0 = 0.1;                      %���
seconds = 30;                  %�����
iterations = ceil(seconds/t0); %��������
time = 0:t0:seconds;

%������������� ��������
x1 = zeros(1,iterations);
x2 = zeros(1,iterations);
psi = zeros(1,iterations);
xi1 = zeros(1,iterations);

% ��������� �������� (�� 0 ����. � ������� � 1)
x1(1,1) = prey;
x2(1,1) = predators;
psi(1,1) = x1(1,1) - rho*x2(1,1); %�� ������� ������� ��������� � ����
xi1(1,1) = normrnd(0,0.1); %��� ������ �� ���������� � ����������� (�.�. ����� 0, �.�.�. ����� 0.1)

%���������� �������� �� k = 1 ���� ��� ��������� ������. ���
%������� � �������������� �������� k - 1 (��������, x1)
xi1(1,2) = normrnd(0,0.1);
x1(1,2) = -(lambda + c)*psi(1,1) + rho*(x2(1,1) + t0*(x2(1,1)*(delta*x1(1,1) - gamma))) + t0*(xi1(1,2) + c*xi1(1,1));
x2(1,2) = x2(1,1) + t0*(x2(1,1)*(delta*x1(1,1) - gamma));

for k = 2:iterations
    xi1(1,k + 1) = normrnd(0,0.1); %��� ������ �� ���������� � ����������� (�.�. ����� 0, �.�.�. ����� 0.1)
    psi(1,k) = x1(1,k) - rho*x2(1,k); %�� ������� ������� ��������� � ����
    x1(1,k + 1) = -(lambda + c)*psi(1,k) - c*lambda*psi(1,k - 1) + rho*(x2(1,k) + t0*(x2(1,k)*(delta*x1(1,k) - gamma))) + ...
        t0*(xi1(1,k + 1) + c*xi1(1,k));
    x2(1,k + 1) = x2(1,k) + t0*(x2(1,k)*(delta*x1(1,k) - gamma));
end

%��������� ������� 1
figure('Name','������� 1');
plot(time, x1, 'r', time, x2, 'b')
animal = legend('������','�������');
xlabel('�����')
ylabel('���������� ������')
set(animal)
line2 = sprintf('alpha = %.1f, beta=%.1f, gamma=%.1f, delta=%.1f, lambda=%.1f, c=%.3f, rho=%.1f, t0 = %.1f',...
    alpha, beta, gamma, delta, lambda, c, rho, t0);
title(line2)
%��������� ������� 2
figure('Name','������� 2');
plot(x1, x2)
xlabel('������')
ylabel('�������')
title('������� ���������')