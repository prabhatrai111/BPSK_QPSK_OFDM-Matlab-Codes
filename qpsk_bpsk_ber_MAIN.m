% PRABHAT KUMAR RAI --- EE18MTECH01005
% PROBLEM  -- BPSK-QPSK BER COMPARISON

clear all; close all; clc;
N = 10000; % number of bits or symbols

inp_msg = rand(1,N)>0.5; % generating 0,1 input message

% BPSK Transmitter
x_bpsk = 2*inp_msg-1; % BPSK modulation 0 = -1, 1 = 1 

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

% Generation of noise
noise=randn(1,N); noise2=randn(1,N/2);
Eb_No_dB = [0:10]; % multiple Eb/No values in dB's

for p = 1:length(Eb_No_dB)
   % Noise addition to BPSK signal
   corrp_bpsk = x_bpsk + 10^(-Eb_No_dB(p)/20)*1/sqrt(2)*[noise + 1i*noise];
   
   % Adding noise to QPSK signal
   corrp_qpsk = x_qpsk + 10^(-Eb_No_dB(p)/20)*1/sqrt(2)*[noise2 + 1i*noise2]; 
     
   % Demodulating the BPSK Signal
   bpsk_dmod=real(corrp_bpsk);
   out_bpsk=bpsk_dmod>0;
   
   % calculating the number of bit errors of BPSK
   NError_bpsk(p) = biterr(inp_msg, out_bpsk);
   
   % Demodulation of QPSK signal
   q=1; qpsk_dmod=[];
   for m=1:length(corrp_qpsk)
       qpsk_dmod(q)=real(corrp_qpsk(m));
       qpsk_dmod(q+1)=imag(corrp_qpsk(m));
       q=q+2;
   end
   out_qpsk=qpsk_dmod>0;  
   
   % Calculating the number of bit errors of QPSK
   Nerror_qpsk(p)= biterr(inp_msg, out_qpsk);
   
end
BPSK_Ber = NError_bpsk/N;                       % simulated BER of BPSK
QPSK_Ber = Nerror_qpsk/N;                       % simulated BER of QPSK
bpsk_theory_Ber = 0.5*erfc(sqrt(10.^(Eb_No_dB/10))); % theoretical BER
%bpsk_theory_Ber = qfunc(sqrt(2.*10.^(Eb_No_dB/10))); % theoretical BER
qpsk_theory_Ber = qfunc(sqrt(10.^(Eb_No_dB/10))); 
figure; semilogy(Eb_No_dB,bpsk_theory_Ber,'b.-'); hold on
semilogy(Eb_No_dB,qpsk_theory_Ber,'g.-'); hold on
semilogy(Eb_No_dB, BPSK_Ber,'mx-'); semilogy(Eb_No_dB, QPSK_Ber,'r^-'); 
axis([0 10 10^-5 0.5]); grid on;
legend('By bpsk theory', 'By qpsk theory','By Bpsk simulation','By Qpsk simulation' ); xlabel('Eb/No in dB');
ylabel('Bit Error Rate for BPSK & QPSK'); title('Bit Error Rate curve for BPSK & QPSK modulation');

