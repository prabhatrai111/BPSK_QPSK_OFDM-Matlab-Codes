% PRABHAT KUMAR RAI --- EE18MTECH01005
% PROBLEM  -- BPSK WITH SINC PULSE SHAPING & RECEPTION WITH MATCHED FILTER
% with different sampling instances 1T,1.3T,1.6T
clear all; close all; clc;

% input signal generation with 0 or 1
N=1000;
x_in=rand(1,N)>0.5; 

% bpsk generation 
x_bpsk=2*x_in-1; % conversion into bpsk bits i.e. (1 or -1)

% upsampling the bpsk signal
samp_fact=2;
x_up=upsample(x_bpsk,samp_fact);      % upsampling by 2
%a=1:0.3:1.6;                      % T=1T, T=1.3T, T=1.6T

%for off=1:length(a)
% sinc pulse shaping
lin = linspace(-50,50,21);
%lin=-10*a:(a*1/2):10*a;        % -nT:T/l:nT  T=1, n=10 l=2
%lin=-10:0.5:10;
y1 = sinc(lin);
%stem(y1);
y  = y1/norm(y1);
sinc_shap=conv(x_up,y); % sinc pulse shaping

%-----NOISE GENERATION & ADDITION TO SIGNAl
noise=randn(1,length(sinc_shap));
comp_noise=1/sqrt(2)*(noise+1i*noise); % guassian noise mean=0 variance=1 (approximately)
comp_noise=1/sqrt(2)*noise;
Eb_No_dB = [0:9]; % different Eb/N values

for r = 1:length(Eb_No_dB)
    
    % Noise addition
    corrp = sinc_shap + 10^(-Eb_No_dB(r)/20)*comp_noise;
    
    %----Matched filter
    h_match=conv(conj(y),corrp);
    
    % choosing only best samples of length l*N
    h_match=real(h_match);
    
    h_best=h_match(((length(h_match)/2 + 1)-(samp_fact*N/2)):((length(h_match)/2)+(samp_fact*N/2)));  

    % down sampling
    k_down=downsample(h_best,samp_fact);   % down sampling by 2

    % Demodulating the signal
    out=[];
    for q=1:length(k_down)
        if k_down(q)>0
            out1=1;
        else
            out1=0;  
        end
        out=[out out1];
    end 
    out; % output after demodulation
    out5 = k_down > 0;
    % calculating the number of bit errors
    nError(r) = biterr(x_in , out5);
    simulation_Ber = nError/N; % simulated ber
end
x=simulation_Ber;
semilogy(Eb_No_dB,simulation_Ber,'.-'); axis([0 10 10^-5 0.5]);
hold on;
%end
hold on;
theory_Ber = 0.5*erfc(sqrt(10.^(Eb_No_dB/10))); % theoretical ber 
semilogy(Eb_No_dB,theory_Ber,'b*-'); hold on
legend('1 T','Theory'); xlabel('Eb/No, dB');
axis([0 10 10^-5 0.5]); grid on;
ylabel('Bit Error Rate'); 
title('Bit error probability curve for BPSK modulation for sinc pulse shaping');