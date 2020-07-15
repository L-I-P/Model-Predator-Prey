%���������� �����
prey = 1;
%���������� ��������
predators = 1;

%���
t0 = 0.01;
%����� � ��������
seconds = 10;
%���������� ��������(���������� ����� �� �������)
iterations = ceil(seconds/t0);

%�������� ����� ��� ������ �������������
fid = fopen('parametrs.txt','a');

%alpha �� �����������, ������ ��� ����������� 1-�� ������� (��� 1.�)
for alpha = 1: 1: 1.0
    %beta �� �����������, ������ ��� ����������� 1-�� ������� (��� 1.�)
    for beta = 1: 1: 1.0
        for gamma = 0.0: 0.2: 1.0
            for delta = 0.0: 0.2: 1.0
                for lambda = 0.0: 0.2: 1.0       %0 <= l <= 1
                    for rho = 0.0: 0.2: 1.0      %0 <= r <= 1
                        
                        %����������� ��������. ���� ��� �������� x1 � x2 ��� ������� ������������� ��������, �� test = 1
                        test = 1;
                        
                        %������������� ��������
                        x1 = zeros(iterations);
                        x2 = zeros(iterations);
                        psi = zeros(iterations);
                        xi1 = zeros(iterations);
                        
                        c = 0.001;     %0.001 <= c <= 0.01
                        
                        % ��������� �������� (�� 0 ����. � ������� � 1)
                        x1(1) = prey;
                        x2(1) = predators;
                        psi(1) = x1(1) - rho*x2(1); %�� ������� ������� ��������� � ����
                        xi1(1) = normrnd(0,0.1); %��� ������ �� ���������� � ����������� (�.�. ����� 0, �.�.�. ����� 0.1)
                        
                        %���������� �������� �� k = 1 ���� ��� ��������� ������. ���
                        %������� � �������������� �������� k - 1 (��������, x1)
                        xi1(2) = normrnd(0,0.1);
                        x1(2) = -(lambda + c)*psi(1) + rho*(x2(1) + t0*(x2(1)*(delta*x1(1) - gamma))) + t0*(xi1(2) + c*xi1(1));
                        x2(2) = x2(1) + t0*(x2(1)*(delta*x1(1) - gamma));
                        
                        for k = 2:iterations
                            xi1(k + 1) = normrnd(0,0.1); %��� ������ �� ���������� � ����������� (�.�. ����� 0, �.�.�. ����� 0.1)
                            psi(k) = x1(k) - rho*x2(k); %�� ������� ������� ��������� � ����
                            x1(k + 1) = -(lambda + c)*psi(k) - c*lambda*psi(k - 1) + rho*(x2(k) + t0*(x2(k)*(delta*x1(k) - gamma))) + ...
                                t0*(xi1(k + 1) + c*xi1(k));
                            x2(k + 1) = x2(k) + t0*(x2(k)*(delta*x1(k) - gamma));
                            %��������� ������ ������������
                            if x1(k) > 143 || x2(k) > 143
                                test = 0;
                            end
                        end
                        %������� ������
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