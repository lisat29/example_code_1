% BMEN 6003: Computational Modeling of Physiologic Systems
% Tetracycline repressor (tetR) Autoregulatory Circuit
% Lisa Torres

clc;
clear all;
close all;

alpha = 10^-4; % 1/s
beta = 100*10^-12; % pmol/s
tau = 75*60; % 75 mins to s
k = 10*10^-9; % nmol
t = 1:0.1:2*tau; % s

% coopertivity, 0 being no repression and 5 being the max value
n = 0:5;

% normalized concentration = concentration / steady state concentration
x_norm = zeros(length(n),length(t));

for n = 0:5
    x_norm(n+1,:) = (1 - exp(-alpha*(n + 1)*t)).^(1/(n + 1)); 
end

figure(1)
plot(t,x_norm(1,:),t,x_norm(2,:),t,x_norm(3,:),t,x_norm(4,:)...
    ,t,x_norm(5,:),t,x_norm(6,:));
title('Normalized Cellular Concetration of tetR')
legend('No repression','n = 1','n = 2','n = 3','n = 4','n = 5')
xlabel('Time (secs)')
ylabel('Normalized Cellular Conentration')

x_non = zeros(length(n),length(t));

for n = 0:5
    x_st = ((beta*k^n)/alpha).^(1/(n+1));
    x_norm = (1 - exp(-alpha*(n + 1)*t)).^(1/(n + 1)); 
    
    x_non(n+1,:) = x_norm*x_st;
end

figure(2)
semilogy(t/tau,x_non(1,:),t/tau,x_non(2,:),t/tau,x_non(3,:),...
    t/tau,x_non(4,:),t/tau,x_non(5,:),t/tau,x_non(6,:));

legend('No repression','n = 1','n = 2','n = 3','n = 4','n = 5')
title('Non-Normalized Cellular Concetration of tetR')
xlabel('Time (secs)')
ylabel('Cellular Conentration')