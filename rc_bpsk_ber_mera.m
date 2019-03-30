% PRABHAT KUMAR RAI --- EE18MTECH01005
% PROBLEM  -- BPSK WITH RC SHAPING with different alpha with different sampling instances 1T,1.1T,1.2T

clear all; close all; clc;
% input signal generation with 0 or 1
N = 10000;
x_in = rand(1,N)>0.5; 

% bpsk generation 
x_bpsk = 2*x_in - 1; % conversion into bpsk bits i.e. (1 or -1)

% upsampling the bpsk signal
samp_fact = 2;
x_up = upsample(x_bpsk, samp_fact);      % upsampling by 2
a = 1:0.1:1.2;                      % T=1T, T=1.1T, T=1.2T
Eb_No_dB = [0:9]; % different Eb/N values

for off = 1:length(a)
    
    % raised cosine pulse shaping
    t = -10*a(off):(a(off)*1/2):10*a(off);        % -nT:T/l:nT  T=1, n=10 l=2
    alpha = [0.2 0.5];
    simulation_Ber = [];
    
    for al = 1:length(alpha)
        y1 = sinc(t);
        y2 = y1/norm(y1);
        cosp = cos(alpha(al)*pi*t)./(1-(2*alpha(al)*t).^2);
        cosinfpos = find(abs(cosp)==inf);
        cosp(cosinfpos) = pi/4;
        y = y2.*cosp;
        sinc_shap=conv(x_up,y); % sinc pulse shaping

        %-----NOISE GENERATION & ADDITION TO SIGNAl
    
        noise = randn(1,length(sinc_shap));
        comp_noise = 1/sqrt(2)*(noise+1i*noise); % guassian noise mean=0 variance=1 (approximately)

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
            out = k_down > 0;

            % calculating the number of bit errors
            nError(r) = biterr(x_in , out);
%             simulation_Ber = nError/N; % simulated ber
        end 
        simulation_Ber = [simulation_Ber; nError/N]; % simulated ber
    end        
    theory_Ber = 0.5*erfc(sqrt(10.^(Eb_No_dB/10))); % theoretical ber 
    subplot(2,2,off);
    semilogy(Eb_No_dB,simulation_Ber(1,:),'g*-'); axis([0 10 10^-5 0.5]); hold on;
    semilogy(Eb_No_dB,simulation_Ber(2,:),'r.-'); axis([0 10 10^-5 0.5]); hold on;
    semilogy(Eb_No_dB,theory_Ber,'b*-'); hold on;
    legend(sprintf('rc alpha = %f',alpha(1)),sprintf('rc alpha = %f',alpha(2)),'Theory');
    xlabel('Eb/No, dB'); axis([0 10 10^-5 0.5]); grid on; ylabel('Bit Error Rate'); 
    title(sprintf('BER for BPSK Raised Cosine pulse at samp rate %f',a(off)));
end
