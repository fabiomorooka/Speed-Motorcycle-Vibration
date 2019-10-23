clc
clear all
close all

ms = 75 ; mb = 120; mp = 50; mf = 20; mr = 20;
%Ms = Massa do piloto e cadeira
%Mb = Massa do ve�culo
%Mp = Momento de in�rcis
%Mf = Massa da suspens�o traseira
%Mr = Massa da suspens�o frente

M = [ms 0 0 0 0
     0 mb 0 0 0
     0 0 mp 0 0
     0 0 0 mf 0
     0 0 0 0 mr]
 
 cs = 550; cf = 1200; cr = 800; 
 %Cs = Amortecimento do piloto
 %Cf = Amortecimento de tr�s
 %Cr = Amortecimento da frente
 
 l1 = 0.300; l2 = 0.650; l3 = 0.800; 
 %l1 = dist�ncia do centro de massa at� o motorista
 %l2 = dist�ncia do centro de massa at� a parte da frente
 %l3 = dist�ncia do centro de massa at� a parte de tr�s
 
 C = [cs -cs (cs*l1) 0 0
      -cs (cs+cf+cr) (-cs*l1-cf*l2+cr*l3) -cf -cr
      (cs*l1) (-cs*l1-cf*l2+cr*l3) (cs*l1*l1+cf*l2*l2+cr*l3*l3) (cf*l2) (-cr*l3)
       0 -cf (cf*l1) cf 0
       0 -cr (-cr*l3) 0 cr]
   
ks = 2300; kf = 16000; kr = 90000; ktf = 25000; ktr = 25000;
%Ks = Mola do piloto
%Kf = Mola da traseira
%Kr = Mola da frente
%Ktf = Mola da traseira em baixo
%Ktr = Mola da fernte em baixo

K = [ks -ks ks*l1 0 0
    -ks (ks+kf+kr) (-ks*l1-kf*l2+kr*l3) -kf -kr
    ks (-ks*l1-kf*l2+kr*l3) (ks*l1*l1+kf*l2*l2+kr*l3*l3) (kf*l2) (-kr*l3)
    0 -kf (kf*l2) (kf+ktf) 0
    0 -kr (-kr*l3) 0 (kr+ktr)]

