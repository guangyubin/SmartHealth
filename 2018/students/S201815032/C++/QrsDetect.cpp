#include "Qrsdetect.h"
#include <math.h>//引入绝对值函数；
#include <stdio.h>
    



//从matlab中求出a，b系数；
         




//int QrsDetect_flag = 0;


float bpfilter(float xn)
{
	static const int OrderA = 5;
	static const int OrderB = 5;
	static const float Ceof_A[OrderA] = { 1, -3.39756791945667, 4.49126771653074, -2.73830049324164, 0.652837763407545 };
	static const float Ceof_B[OrderB] = { 0.0186503962278372, 0, -0.0373007924556744, 0, 0.0186503962278372 };
	static float buffer_x[OrderA] = { 0 }; //使一维数组内的五个都是零；
	static float buffer_y[OrderB] = { 0 };
	static int filter_index = 0;


	float tmpx = Ceof_B[0] * xn;;
	int ptr = filter_index;
	for (int i = 1; i < OrderB; i++)
	{
		tmpx += buffer_x[ptr] * Ceof_B[i];
		ptr--;
		if (ptr < 0)  ptr = OrderB - 1;
	}

	float tmpy = 0;
	ptr = filter_index;
	for (int j = 1; j < OrderA; j++)
	{
		tmpy += buffer_y[ptr] * Ceof_A[j ];
		ptr--;
		if (ptr < 0)  ptr = OrderA - 1;
	}
	float yn = tmpx - tmpy ;	
	filter_index++;
	if (filter_index == 5) filter_index = 0;
	buffer_y[filter_index] = yn;
	buffer_x[filter_index] = xn;
	return yn;

}

//*依据差分方程写滤波器；
float diff(float xn)
{
	static float xn1 = 0;
	float yn = xn -xn1;  
	xn1 = xn;
	yn = fabs(yn);//直接利用绝对值函数求差分；
	return yn;
}
// y(n) = y(n-1) + x(n) - x(n-N)
float smooth(float xn)
{

	// 

	static const int NSmooth = 25;
	static float buffer_x[NSmooth] = { 0 };
	static float yn1 = 0;
	static int ptrBuff = 0;

	int ptr = ptrBuff;
	yn1 +=  xn - buffer_x[ptr];


	buffer_x[ptrBuff] = xn;
	ptrBuff++;
	if (ptrBuff == NSmooth)  ptrBuff = 0;


	return yn1/ NSmooth;

}

int median(int *array, int datnum)
{
	int i, j, k, temp, sort[20];
	for (i = 0; i < datnum; ++i)
		sort[i] = array[i];
	for (i = 0; i < datnum; ++i)
	{
		temp = sort[i];
		for (j = 0; (temp < sort[j]) && (j < i); ++j);
		for (k = i - 1; k >= j; --k)
			sort[k + 1] = sort[k];
		sort[j] = temp;
	}
	return(sort[datnum >> 1]);
}
int QrsDectet(int x)
{
	static int count = 0;
	static int sampleRate = 250;
	static int det_thresh = 0;

	static int initMax = 0, nInitPeaks = 0;
	static int peaksbuf[8];

	static int flag = 0; 
	static int delay = 0;

	int datum = smooth(diff(bpfilter(x)));
	count++;

	int isQrs = 0;
	if (nInitPeaks  < 8)
	{
		if (datum > initMax) initMax = datum;
		if (count%sampleRate == 0)
		{
			peaksbuf[nInitPeaks] = initMax;
			initMax = 0; 
			flag = 0; 
			nInitPeaks++;
			if (nInitPeaks == 8)
			{
				det_thresh = median(peaksbuf, 8)*0.5;
			}
		}
	}
	else
	{
	
		switch (flag)
		{
		case 0:
			if(datum > det_thresh)
				flag = 1;
			break;
		case 1:
			delay++;
			if (delay == 10)
			{
				flag = 2;
			}
			break;
		case 2:

			if(datum < det_thresh)
			{
				isQrs = 1;
				flag = 3;
			}
			break;
		case 3:
			delay++;
			if (delay < 250*0.3)
			{
				flag = 0; 
				delay = 0;
			}
			break;
		}	
	}

	return isQrs;

}

//
//float smooth(float xn[])
//{	float yn[] = {};
//	sum =0;
//	for(int j=0;j<size;j++)
//	{
//		if(j<N/2)
//		{
//			for(int k=0;k<N;k++)
//			{
//				sum+=xn[j+k];
//			}
//			xn[j]=sum/N;//若j<N/2,则直接取前几位数的平均值；
//		}
//		else
//			if(j<size-N/2)
//			{
//				for(int k=0;k<N/2;k++)
//			{	
//				sum+=(xn[j+k]+xn[j-k]);
//			}
//			xn[j]=sum/N;//取j前后各k位数,计算size-N/2前所有数的平均值；
//			{
//			else
//			}
//				for(int k=0;k<size-j;k++)
//			{
//				sum+=xn[j-k];
//			}
//			xn[j]=sum/N;
//		}
//		yn[]=xn[j]
//		sum=0;
//	}
//	return yn[];
//}

