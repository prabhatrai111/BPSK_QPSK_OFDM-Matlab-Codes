% PRABHAT KUMAR RAI --- EE18MTECH01005
% CSP ASSIGNMENT
% PROBLEM  -- BPSK-OFDM BER

clear all; close all; clc;
N = 2048; % Number of bits or symbols
fft_len = 2048; cp_len = 144;  % fft length & CP length

% BPSK Transmitter
inpu = rand(1,N) > 0.5; % generating 0,1 
x_bpsk = 2*inpu - 1;    % BPSK modulation 0 = -1, 1 = 1 


% OFDM conversion
x_ifft = sqrt( fft_len )*ifft( x_bpsk, fft_len );

% Adding CP to OFDM symbol
ff = x_ifft( ( fft_len - cp_len + 1 ): fft_len );
ofdm_sym = cat( 2, ff, x_ifft );

% Generation of Noise
noise = randn( 1, length(ofdm_sym) );
comp_noise = ( 1/sqrt(2) )*( noise + 1i*noise );
noise2 = randn( 1, length(x_bpsk) );
comp_noise = ( 1/sqrt(2) )*( noise + 1i*noise );
comp_noise2 = ( 1/sqrt(2) )*( noise2 + 1i*noise2 );
Eb_No_dB = [ 0 : 10 ]; % multiple Eb/No values in dB's
 
for p = 1:length(Eb_No_dB)
    
    % Noise addition to bpsk-ofdm signal
    corrp_ofdm = ofdm_sym + 10^( -Eb_No_dB(p)/20 )*comp_noise;
 
    % Removing CP
    cp_remove = corrp_ofdm( ( cp_len + 1 ): ( fft_len + cp_len ) );
 
    % Taking FFT
    x_fft = fft( cp_remove, fft_len );
 
    % Demodulating the signal
    bpsk_d = real( x_fft );
    outpu = [];
    for q = 1 : length(bpsk_d)
        if bpsk_d(q) > 0
            outpu1 = 1;
        else
            outpu1 = 0;
        end
        outpu = [outpu outpu1];
    end
    
    % calculating the number of bit errors
    nError_ofdm(p) = biterr(inpu , outpu);
    
   % Noise addition to bpsk signal
   corrp_bpsk = x_bpsk + 10^(-Eb_No_dB(p)/20)*comp_noise2; % AWGN with different dB's
   % Demodulating the signal
   k_d=real(corrp_bpsk);
   out=[];
   for q=1:length(k_d)
       if k_d(q)>0
           out1=1;
       else
           out1=0;
       end
       out=[out out1];
   end
   % calculating the number of bit errors
   nError_bpsk(p) = biterr(inpu , out);
    
 end
simulate_Ber_ofdm = nError_ofdm/N; % simulated BER-OFDM
simulate_Ber_bpsk = nError_bpsk/N; % simulated BER-BPSK
theory_Ber = 0.5*erfc( sqrt( 10.^( Eb_No_dB/10 ))); % theoretical BER

figure; semilogy( Eb_No_dB, theory_Ber, 'b.-' ); hold on
semilogy( Eb_No_dB, simulate_Ber_ofdm, 'mx-');
semilogy( Eb_No_dB, simulate_Ber_bpsk, '*-');axis([0 10 10^-5 0.5]); grid on;
legend('By theory', 'By simulation ofdm', 'by bpsk'); xlabel('Eb/No in dB');
ylabel('Bit Error Rate for BPSK'); title('BER curve for BPSK-OFDM modulation');
