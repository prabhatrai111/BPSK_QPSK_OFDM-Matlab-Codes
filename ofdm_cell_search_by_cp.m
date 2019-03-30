% PRABHAT KUMAR RAI --- EE18MTECH01005
% PROBLEM  -- CP Cell Search

clear all; close all; clc;
N = 2048; % Number of bits or symbols
fft_len = N; cp_len = 144;  % fft length & CP length
N_symb = 4;
Total_ofdm = [];
% BPSK Transmitter
for l = 1 : N_symb
    input = rand( 1, N ) > 0.5; % generating 0,1
    x_bpsk = 2 * input - 1;    % BPSK modulation 0 = -1, 1 = 1
    
    % OFDM conversion
    x_ifft = sqrt( fft_len ) * ifft( x_bpsk, fft_len );
    
    % Adding CP to OFDM symbol
    cp = x_ifft( ( fft_len - cp_len + 1 ): fft_len );
    
    Total_ofdm = [ Total_ofdm cp x_ifft ];
end

% Generation of Noise
noise = randn( 1, length( Total_ofdm ) );
comp_noise = ( 1 / sqrt( 2 ) ) * ( noise + 1i * noise );
Eb_No_dB = [ 0 : 10 ]; % multiple Eb/No values in dB's

for p = 1:length(Eb_No_dB)

    % Noise addition to bpsk-ofdm signal
    corrp_ofdm = Total_ofdm + 10 ^ ( - Eb_No_dB( p ) / 20 ) * comp_noise;
    offset = 50; error = 0;
    
    % Received Signal
    y = corrp_ofdm ( offset : end );

    % CP Cell Search
    z_add = 0;  h = [];
     for k = 1 : length( y ) - cp_len - fft_len
         z_add = 0;
            for n = 1 : cp_len
                     c = y( n + k ) * conj( y ( n + fft_len + k ) );
                     z_add = z_add + c;           
            end 
            h( k ) = z_add ;
     end
    figure; plot(abs(h)); title(sprintf("Graph for SNR = %d",Eb_No_dB(p)));
    % Index Estimation
    [ offset_1, index_1 ] = max ( h ( 1 : 1950 ) );
    [ offset_2, index_2 ] = max ( h ( 1950 : 3900 ) );
    [ offset_3, index_3 ] = max ( h ( 3900 : 5850 ) );
    [ offset_4, index_4 ] = max ( h ( 5850 : end ) );
    
    % Delay Estimation
    delay_2 =  ( index_2 + 1950 - N - cp_len - 1 );
    delay_3 = abs ( index_3 + 3900 - 2*( N + cp_len ) + 1 );
    delay_4 = abs ( index_4 + 5850 - 3*( N + cp_len ) + 1 );
    avg_delay = round ( ( delay_2 + delay_3 + delay_4 ) / 3 );
    
     % Symbol Estimation
    symbol_2 = y ( index_2 + 1950 + cp_len : index_2 + 1950 + cp_len + N );
    symbol_3 = y ( index_3 + 3900 + cp_len : index_3 + 3900 + cp_len + N );
    symbol_4 = y ( index_4 + 5850 + cp_len : end );

    % Taking FFT
    x_fft_2 = fft( symbol_2, fft_len );
    x_fft_3 = fft( symbol_3, fft_len );
    x_fft_4 = fft( symbol_4, fft_len );

    % Demodulating the signal
    bpsk_d_2 = real( x_fft_2 );
    bpsk_d_3 = real( x_fft_3 );
    bpsk_d_4 = real( x_fft_4 );
    outpu = [];
    decoded_symb_2 = bpsk_d_2 > 0;   % Decoded Symbol number 2
    decoded_symb_3 = bpsk_d_3 > 0;   % Decoded Symbol number 3
    decoded_symb_4 = bpsk_d_4 > 0;   % Decoded Symbol number 4
end

