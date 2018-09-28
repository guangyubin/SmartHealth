#include "QrsDetect.h"
float Ceof_A[5] = {1,-3.39756791945667,4.49126771653074,-2.73830049324164,0.652837763407545}; 
float Ceof_B[5] = {0.0186503962278372,0,-0.0373007924556744,0,0.0186503962278372};
float yn1,yn2,yn3,yn4 = 0;
float xn1,xn2,xn3,xn4 = 0;

float bpfilter(float xn)
{	
	

	return yn;
}
float qrsfilter(float x)
{
	return 0;
}

float diff(float x)
{	
	static float xn1 = 0;
	float y = xn - xn1;
	xn1 = xn;
	return y;
}
float smooth(float x)
{
	return 0;
}