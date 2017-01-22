close all; clear all;

n=10000;
I=0.5; %strong influence
A=[-0.9 0; I -0.9];
S=[1 0; 0 1];
D=10; %additional time points to reach "steady state"

%calling AR model to simulate the time series;
v=arsim(zeros(1,2),A,S,n+2000+D);
v=v(1:n,:);

subplot(211); hold on; plot(v(:,1),'r'); %time series "X";
legend({'X'});
subplot(212); hold on; plot(v(:,2),'b'); %time series "Y";
legend({'Y'});
xlabel('time (sample)');

%calculate the granger
[granger, granger_F, granger_p]=etc_granger(v,1);