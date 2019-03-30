#include <stdio.h>
#include <stdlib.h>

int main()
{
    int a1,b,c1,x1,y1, pow_2;
    float x,y,z1,z2,a2,a3,c3,c2,a4;

    do{
            printf("enter bit precision which have multiple of 8 like 8,16,32 -- ");
            scanf("%d",&b);
      }while(b % 8 !=0);
      printf("we are using %d bit precision \n",b);
      printf("enter the 1st number for addition or subtract with sign  = ");
      scanf("%f",&x);
      printf("\nenter the 2nd number for addition or subtract with sign = ");
      scanf("%f",&y);

      x1 = x/1; y1 = y/1;

      if (x1 >= y1)
      {
           if (x1 >= 16)
           {
                    pow_2 = 6;
                    a4=pow(2,(b - pow_2));
                    a2=x*a4;a1=x*a4;a3=a2-a1;
                    if (a3>0.5)
                    {
                        a1=a1+1;
                     }
                    else
                    {
                        a1=a1;
                    c2=y*a4;c1=y*a4;c3=c2-c1;
                    }

                    if (c3>0.5)
                    {
                        c1=c1+1;
                    }
                    else
                     {   c1=c1;
                    z1=(c1+a1)/a4; }
                    }
             else if ( x1 >= 8 && x1 < 16)
            {
                    pow_2 = 5;
                    a4=pow(2,(b - pow_2));
                    a2=x*a4;a1=x*a4;a3=a2-a1;
                    if (a3>0.5)
                        a1=a1+1;
                    else
                        a1=a1;
                    c2=y*a4;c1=y*a4;c3=c2-c1;
                    if (c3>0.5)
                        c1=c1+1;
                    else
                        c1=c1;
                    z1=(c1+a1)/a4;
                    }
            else if ( x1 >= 3 && x1 < 8)
                    {pow_2 = 3;
                    a4=pow(2,(b - pow_2));
                    a2=x*a4;a1=x*a4;a3=a2-a1;
                    if (a3>0.5)
                        a1=a1+1;
                    else
                        a1=a1;
                    c2=y*a4;c1=y*a4;c3=c2-c1;
                    if (c3>0.5)
                        c1=c1+1;
                    else
                        c1=c1;
                    z1=(c1+a1)/a4;}
            else if ( x1 >= 0 && x1 < 3)
                   { pow_2 = 2;
                    a4=pow(2,(b - pow_2));
                    a2=x*a4;a1=x*a4;a3=a2-a1;
                    if (a3>0.5)
                        a1=a1+1;
                    else
                        a1=a1;
                    c2=y*a4;c1=y*a4;c3=c2-c1;
                    if (c3>0.5)
                        c1=c1+1;
                    else
                        c1=c1;
                    z1=(c1+a1)/a4;
                    }
                    }

      else
      {
            if (y1 >= 16)
              {
                    pow_2 = 6;
                    a4=pow(2,(b - pow_2));
                    a2=x*a4;a1=x*a4;a3=a2-a1;
                    if (a3>0.5)
                        a1=a1+1;
                    else
                        a1=a1;
                    c2=y*a4;c1=y*a4;c3=c2-c1;
                    if (c3>0.5)
                        c1=c1+1;
                    else
                        c1=c1;
                    z1=(c1+a1)/a4;
                    }
            else if ( y1 >= 8 && y1 < 16)
            {
                    pow_2 = 5;
                    a4=pow(2,(b - pow_2));
                    a2=x*a4;a1=x*a4;a3=a2-a1;
                    if (a3>0.5)
                        a1=a1+1;
                    else
                        a1=a1;
                    c2=y*a4;c1=y*a4;c3=c2-c1;
                    if (c3>0.5)
                        c1=c1+1;
                    else
                        c1=c1;
                    z1=(c1+a1)/a4;
                    }
             else if ( y1 >= 3 && y1 < 8)
             {
                    pow_2 = 3;
                    a4=pow(2,(b - pow_2));
                    a2=x*a4;a1=x*a4;a3=a2-a1;
                    if (a3>0.5)
                        a1=a1+1;
                    else
                        a1=a1;
                    c2=y*a4;c1=y*a4;c3=c2-c1;
                    if (c3>0.5)
                        c1=c1+1;
                    else
                        c1=c1;
                    z1=(c1+a1)/a4;
                    }
            else if ( y1 >= 0 && y1 < 3)
            {
                    pow_2 = 2;
                    a4=pow(2,(b - pow_2));
                    a2=x*a4;a1=x*a4;a3=a2-a1;
                    if (a3>0.5)
                        a1=a1+1;
                    else
                        a1=a1;
                    c2=y*a4;c1=y*a4;c3=c2-c1;
                    if (c3>0.5)
                        c1=c1+1;
                    else
                        c1=c1;
                    z1=(c1+a1)/a4;
            }
            }


                    z2=x+y;
                    printf("actual addition or subtraction is = %f",x+y);
                    printf("\n%d bit precision value for addition or subtraction is = %f",b,z1);
                    printf("\nerror = %f",z2-z1);
    return 0;
}
