
clc
clear all
close all

ms = 75 ; mb = 120; mp = 50; mf = 20; mr = 20;
%Ms = Massa do piloto e do assento (mass of driver and chair)
%Mb = Massa do ve�culo (mass of automobile structure)
%Mp = Momento de in�rcia
%Mf = Massa da suspens�o frente (nonspring supported mass of front suspension)
%Mr = Massa da suspens�o traseira (nonspring supported mass of rear suspension)

M = [ms 0 0 0 0
     0 mb 0 0 0
     0 0 mp 0 0
     0 0 0 mf 0
     0 0 0 0 mr];
 
 cs = 550; cf = 1200; cr = 800; 
 %Cs = Amortecimento do piloto (damping coefficient of the chair)
 %Cf = Amortecimento de tr�s
 %Cr = Amortecimento da frente
 
 l1 = 0.300; l2 = 0.650; l3 = 0.800; 
 %l1 = dist�ncia do centro de massa at� o motorista (the distance between chair and vehicle mass center)
 %l2 = dist�ncia do centro de massa at� a parte da frente (the distance from the vehicle mass center to front wheel axles)
 %l3 = dist�ncia do centro de massa at� a parte de tr�s (the distance from the vehicle mass center to rear wheel axles)
 
 C = [cs -cs (cs*l1) 0 0
      -cs (cs+cf+cr) (-cs*l1-cf*l2+cr*l3) -cf -cr
      (cs*l1) (-cs*l1-cf*l2+cr*l3) (cs*l1*l1+cf*l2*l2+cr*l3*l3) (cf*l2) (-cr*l3)
       0 -cf (cf*l1) cf 0
       0 -cr (-cr*l3) 0 cr];
   
ks = 2300; kf = 16000; kr = 90000; ktf = 25000; ktr = 25000;
%Ks = Mola do piloto (rigidity coefficient of the chair)
%Kf = Mola da frente (rigidity coefficient of front suspension)
%Kr = Mola da traseira (rigidity coefficient of rear suspension)
%Ktf = Mola da traseira em baixo (rigidity coefficient of front wheel)
%Ktr = Mola da fernte em baixo (rigidity coefficient of rear wheel)

K = [ks -ks ks*l1 0 0
    -ks (ks+kf+kr) (-ks*l1-kf*l2+kr*l3) -kf -kr
    ks (-ks*l1-kf*l2+kr*l3) (ks*l1*l1+kf*l2*l2+kr*l3*l3) (kf*l2) (-kr*l3)
    0 -kf (kf*l2) (kf+ktf) 0
    0 -kr (-kr*l3) 0 (kr+ktr)];

%-------------------------------------------------------------
% Definiremos, agora, os par�metros A, B, C e D do nosso sistema
% no espa�o de estados.
aux1 = [[C]  [M],
        [M] zeros(5)];
aux2 = [[K]   zeros(5),
        zeros(5) -[M]];
B = inv(aux1);
A = B*(-aux2);
C = eye(10);
D = zeros(10);

% Definindo um objeto "sistema" no MatLab, atrav�s de A, B, C e D:
sistema = ss(A, B, C, D);

% Obtendo a fun��o transfer�ncia do sistema:
sys=tf(sistema);

% Definindo os par�metros da entrada. Realizaremos a simula��o do ve�culo
% perante � excita��o gerada pelo desbalanceamento do motor.
Fs=50;
t=0:1/Fs:4;
L=length(t);
v_zero=zeros(1,L);

% Definindo o vetor que representa a entrada do sistema (For�a
% desbalanceada no rotor):
% An�lise de 0 a 4s
w = 85.45;  % maior frequ�ncia natural mais alta (13.61 Hz) 
e = 0.010;  % 10 mm
md = 6.45;  % massa desbalanceada no rotor (10% da massa do motor)
F = (w^2)*md*e*sin(w*t);

u=[  v_zero; F; v_zero; v_zero; v_zero; 
     v_zero; v_zero; v_zero; v_zero;v_zero]';

% Calculando a resposta por simula��o:
resp = lsim(sys, u, t);


%Graficando os resultados da simula��o:
for i = 1:5
figure();
plot(t,resp(:,i))
num = int2str(i);
title(strcat('Amplitude de deslocamento x Tempo - ','GL: ', num));
xlabel('Tempo [s]')
ylabel('Amplitude da resposta [m]')
end

deltaT = 1/Fs;
resp = diff(resp)/deltaT;
resp = diff(resp)/deltaT;
t = t(1:199); % ajustando o vetor tempo devido � utiliza��o do comando diff

for i = 1:5
figure();
plot(t,resp(:,1))
num = int2str(i);
title(strcat('Acelera��o x Tempo - ', 'GL: ', num));
xlabel('Tempo [s]')
ylabel('Amplitude da acelera��o [m/s^2]')
end

n=2^nextpow2(length(t));
resp_f=fft(resp,n);         % resposta em frequ�ncia
f = Fs*(0:(n/2))/n;      
P = abs(resp_f/n);
y = 1.1*ones(1,length(f));  % limite de seguran�a

figure();
for i = 1:5
plot(f,P(1:n/2+1,i))
plot(f,y)
title('Acelera��o X Frequ�ncia')
xlabel('Frequ�ncia [Hz]')
ylabel('Amplitude da acelera��o [m/s�]')
hold on;
end

legend('1','2','3','4','5')
hold off;