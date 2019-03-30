% PRABHAT KUMAR RAI --- EE18MTECH01005
% PROBLEM  -- QPSK-OFDM BER

clear all; close all; clc;
N=2048;
fft_len = 2048; cp_len = 144;  % fft length & CP length

% input message
inp_msg=rand(1,N)>0.5;

% QPSK Signal Generation
x_qpsk1=[];  x_qpsk=[]; p=1/sqrt(2); 
 for i=1:2:N
       if  inp_msg(i)==1 && inp_msg(i+1)== 0  % 10 --> +p-ip
               x_qpsk1= complex( p,-p);
       else if inp_msg(i)==0 && inp_msg(i+1)==0 % 00 --> -p-ip
               x_qpsk1= complex(-p,-p);
       else if inp_msg(i)==0 && inp_msg(i+1)==1 % 01 --> -p+ip
               x_qpsk1=complex(-p,p);
       else if inp_msg(i)==1 && inp_msg(i+1)==1 % 11 --> +p+ip
               x_qpsk1=complex(p,p);
       end; end; end; end;
       x_qpsk=[x_qpsk x_qpsk1];
 end; 

% OFDM conversion
x_ifft = sqrt( fft_len )*ifft( x_qpsk, fft_len/2 );

% Adding CP to OFDM symbol
ff = x_ifft( ( fft_len/2 - cp_len + 1 ): fft_len/2 );
ofdm_sym = cat( 2, ff, x_ifft );

% noise generation
noise=randn(1,length(ofdm_sym));
comp_noise = 1/sqrt(2)*[noise + 1i*noise];
Eb_No_dB=0:2:10;      % different Eb/N values in dB

for p=1:length(Eb_No_dB)
    % addition with noise
    corrp_ofdm = ofdm_sym + 10^(-Eb_No_dB(p)/20)*comp_noise; % AWGN with different dB's 
    
    % Removing CP
    cp_remove = corrp_ofdm( ( cp_len + 1 ): ( fft_len/2 + cp_len ) );
 
    % Taking FFT
    x_fft = fft( cp_remove, fft_len/2 );
    
   % Demodulation of QPSK signal
   q=1; qpsk_dmod=[];
   for m=1:length(x_fft)
       qpsk_dmod(q)=real(x_fft(m));
       qpsk_dmod(q+1)=imag(x_fft(m));
       q=q+2;
   end
   out_qpsk=qpsk_dmod>0;  
   
   % Calculating the number of bit errors of QPSK
   Nerror_qpsk(p)= biterr(inp_msg, out_qpsk);                %Quadrature BER calculation
%     simulation_Ber(p)=mean([ber1 ber2]);                         %Overall BER
  
 end
QPSK_Ber = Nerror_qpsk/N;
theory_Ber = 0.5*erfc(sqrt(10.^(Eb_No_dB/10))); % theoretical ber
% 
 figure; semilogy(Eb_No_dB,theory_Ber,'b.-'); hold on
 semilogy(Eb_No_dB,QPSK_Ber,'mx-'); axis([0 10 10^-5 0.5]); grid on;
 legend('theory', 'simulation'); xlabel('Eb/No, dB');
 ylabel('Bit Error Rate'); title('Bit error probability curve for QPSK-OFDM modulation');