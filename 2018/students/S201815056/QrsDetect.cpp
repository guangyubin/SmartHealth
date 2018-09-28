#include "QrsDetect.h"

float Ceof_A[5] = {1,-3.39756791945667,4.49126771653074,-2.73830049324164,0.652837763407545};
float Ceof_B[5]={0.0186503962278372,0,-0.0373007924556744,0,0.0186503962278372};
float yn4,yn3,yn2,yn1=0;
float xn4,xn3,xn2,xn1=0;
float bpfilter(float xn)

{	
	float yn = xn*Ceof_B[0] + xn1*Ceof_B[1] + xn2 *Ceof_B[2] + xn3*Ceof_B[3] + xn4 * Ceof_B[4] - yn1 * Ceof_A[1] - yn2 * Ceof_A[2]  - yn3 * Ceof_A[3]  - yn4 * Ceof_A[4] ;	
	yn4=yn3;
	yn3=yn2;      
	yn2=yn1;
	yn1=yn
		;	
	xn4=xn3;	
	xn3=xn2;   
	xn2=xn1;	
	xn1=xn;
	
	return yn;
}
float diff(float yn)
{
	float y=yn-yn1;
	return y;
}
float qrsfilter(float x)
{	
	return 0;
} 
float bpfilter(float x)
{
	return 0;
	
	
}
float diff(float x)
{	
	return 0;
}
float smooth(float x)
{	
	return 0;
}
int QRSDetect(float x)
{
	return 0;
} 

