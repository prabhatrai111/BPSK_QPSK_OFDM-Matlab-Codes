///   PRABHAT KUMAR RAI   ///
///     EE18MTECH01005    ///
///      OFDM Floating    ///

#include <complex.h>
#include <stdio.h>
#include <math.h>

int main()
{
 int x_input[]={1,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,1,0,0,0,1,1,1,1,1,1,0,1,1,0,1,0,0,0,0,1,1,0,0,0,1,1,0,0,1,1,1,0,1,1,0,0,1,0,0,1,1,1,1,1,0,0,0,0};
 int ncp1, ncp2, num = 64, cp_len = 10, x_output[num];
 ncp1 = num + cp_len;
 ncp2 = num - cp_len;
 float ofdm_error[num], sqt = pow( num, 0.5 );
 int a, b, g, c, e, i, f, h, j, k, l, n, m, rem, set, stage, ip_bpsk[num];
 double complex temp[num], BitRev_ifft[num], BitRev_fft[num], cp_Bit[ncp1];// noise[ncp1];
 stage = log2(num);
 double PI = 3.1416;
 double complex z_fft = I * ( -2 * PI / num ), z_ifft = I * ( 2 * PI / num ) ;

 ///  BPSK Generation///
 for ( i = 0; i < num; i++ )
   {                   ip_bpsk[i] = 2 * x_input[i] - 1;           }



 ///  IFFT ///
           /// Bit Reversal  ///
           for ( i = 0; i < num; i++ )
            {                   k = i;
                              set = 0;
                    for ( n = 0; n <= ( stage - 1 ); n++ )
                     {        rem = k % 2;
                                k = k / 2;
                              set = rem * pow( 2, ( stage - 1 - n ) ) + set;
                     }
                   BitRev_ifft[i] = ip_bpsk[set];
            }

           ///    IFFT addition     ///
           for( i = 1; i <= stage; i++)
            {               int increment;
                            increment = pow( 2, i );
                    for( j = 0; j < num; j = j + increment )
                     {
                             int half = 1;
                       for( k = j; k < ( j + increment ) ; k++ )
                        {
                          if( half <= increment/2 )
                           {
                              half++;
                              temp[k] = BitRev_ifft[ ( increment/2 ) - 1 + half - 1 + j ] + BitRev_ifft[ k ];
                           }
                          else
                           {
                              temp[k] = BitRev_ifft[ k - half + 1 ] - BitRev_ifft[ k ];
                           }
                        }
                      }
           ///  Twiddle Multiplication ///
                                    b = pow( 2, ( i - 1 ));
                    if ( i != stage )
                      {             e = 2*increment;
                        for ( g = increment; g < num; g = g + e )
                         {          a = g;
                                    l = 0;
                                    n = a + increment;
                              for ( a = g; a < n; a++ )
                               {
                            temp[ a ] = temp[ a ] * cexp( z_ifft * l );
                                    l = l + ( num / (b*4));
                               }
                        }
                      }
                    else{ printf(" ");}
                    for( m = 0; m < num; m++ )
                     { BitRev_ifft[m] = temp[m];   }
             }
           for(i = 0; i < num ; i++)
             {   BitRev_ifft[i] = BitRev_ifft[i]/sqt; }



 /// CP Addition ///

 for ( i = 0; i < num; i++ )
   {             l = i + cp_len;
         cp_Bit[l] = BitRev_ifft[i];    }
 for ( i = 0; i < cp_len; i++)
   {     cp_Bit[i] = BitRev_ifft[i + ncp2]; }




 /// Noise Generation ///

double complex noise[]={0.000981 +0.000981i,1.026071 +1.026071i,0.802728 +0.802728i,-0.760880 +-0.760880i,0.378201 +0.378201i,0.563608 +0.563608i,-0.340280 +-0.340280i,-0.792340 +-0.792340i,-0.073572 +-0.073572i,-0.148269 +-0.148269i,-0.043294 +-0.043294i,-0.068391 +-0.068391i,-0.295688 +-0.295688i,-1.200884 +-1.200884i,-0.610460 +-0.610460i,-0.307382 +-0.307382i,-0.488025 +-0.488025i,-1.075073 +-1.075073i,-0.170145 +-0.170145i,1.844989 +1.844989i,0.284318 +0.284318i,-0.600136 +-0.600136i,-0.263549 +-0.263549i,0.555064 +0.555064i,0.354859 +0.354859i,0.591116 +0.591116i,1.425877 +1.425877i,-0.872683 +-0.872683i,0.100332 +0.100332i,-0.405556 +-0.405556i,-0.215036 +-0.215036i,-0.443017 +-0.443017i,-0.445551 +-0.445551i,-0.381643 +-0.381643i,-1.616516 +-1.616516i,-0.325021 +-0.325021i,-0.751068 +-0.751068i,0.080051 +0.080051i,0.127938 +0.127938i,0.354499 +0.354499i,0.018070 +0.018070i,-0.303289 +-0.303289i,-0.060905 +-0.060905i,-0.390938 +-0.390938i,0.406219 +0.406219i,0.817463 +0.817463i,-0.536748 +-0.536748i,-0.070730 +-0.070730i,-0.369801 +-0.369801i,-0.161886 +-0.161886i,-0.215770 +-0.215770i,1.168866 +1.168866i,0.683130 +0.683130i,-0.577907 +-0.577907i,0.888608 +0.888608i,0.393174 +0.393174i,-0.682183 +-0.682183i,0.758929 +0.758929i,-1.271598 +-1.271598i,0.159927 +0.159927i,1.253021 +1.253021i,-0.942947 +-0.942947i,-0.553244 +-0.553244i,-0.845501 +-0.845501i,0.189174 +0.189174i,-1.200374 +-1.200374i,-0.063036 +-0.063036i,-1.056691 +-1.056691i,0.003052 +0.003052i,-0.009914 +-0.009914i,0.225768 +0.225768i,0.104132 +0.104132i,-0.998009 +-0.998009i,0.365021 +0.365021i};
double complex pow_noise[ncp1], Noise_pulse[ncp1], no_cp[num];
int ENoBdB[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };


 for ( f = 0; f < 10; f++ )
   {
         double aa = ENoBdB[f] * 1.0 / 20;

           ///  NOISE ADDITION  ///
           for (i = 0; i < ncp1; i++ )
             {        Noise_pulse[i] = ( pow( 10, -aa ) * noise[i] ) + cp_Bit[i];           }

/// CP Removal ///
           for (i=0; i<num; i++)
             {              no_cp[i] = Noise_pulse[ cp_len + i ];    }

/// FFT ///

            /// Bit Reversal  ///
            for ( i = 0; i < num; i++ )
             {                     k = i;
                                 set = 0;
                for ( n = 0; n <= ( stage - 1 ); n++ )
                 {               rem = k % 2;
                                   k = k / 2;
                                 set = rem * pow( 2, ( stage - 1 - n ) ) + set;
                 }
                       BitRev_fft[i] = no_cp[set];
             }

            ///    FFT Addition    ///
            for( i = 1; i <= stage; i++)
             {
                           int increment;
                           increment = pow( 2, i );
                for( j = 0; j < num; j = j + increment )
                  {
                            int half = 1;
                   for( k = j; k < ( j + increment ) ; k++ )
                     {
                       if( half <= increment/2 )
                         {
                             half++;
                             temp[k] = BitRev_fft[ ( increment/2 ) - 1 + half - 1 + j ] + BitRev_fft[ k ];
                         }
                       else
                         {
                             temp[k] = BitRev_fft[ k - half + 1 ] - BitRev_fft[ k ];
                         }
                     }
                  }
            /// Twiddle Multiplication ///
                                   b = pow( 2, i-1);
                if ( i != stage )
                  {                e = 2*increment;
                         for ( g = increment; g < num; g = g + e )
                          {        a = g;
                                   l = 0;
                                   n = a + increment;
                             for ( a = g; a < n; a++ )
                              {
                           temp[ a ] = temp[ a ] * cexp( z_fft * l );
                                   l = l + ( num / (b * 4));
                              }
                          }
                  }
                else{ printf("");}
                for( m = 0; m < num; m++ )
                 {     BitRev_fft[m] = temp[m];   }
             }




/// Demodulation ///

            for(i = 0; i < num; i++)
              {
                if( creal( BitRev_fft[i] ) > 0)
                  {      x_output[i] = 1;   }
                else
                  {      x_output[i] = 0;   }
              }


///     Error     ///
            int Error[num], total_error = 0;

            for ( i = 0; i < num; i++ )
              {             Error[i] = x_input[i] - x_output[i];
                if ( Error[i] == -1 )
                 {          Error[i] = 1;            }
                else
                 {          Error[i] = Error[i];     }
                         total_error = Error[i] + total_error;
              }
            float mean_error;
                          mean_error = ( total_error * 1.0 ) / num;
                       ofdm_error[f] = mean_error;
       printf("\nmean_error = %f, with db=%d", mean_error, f);
   }
  return 0;
}

