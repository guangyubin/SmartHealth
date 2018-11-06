//头文件里面是一些宏定义、全局变量定义、函数声明
#ifndef __1_QRS_DETECT_H__
#define __1_QRS_DERECT_H__
//#include<stdio.h>
#define size  1000//数组大小为1000
#define N 10//滑动平均滤波计算平均值时所取的点数

//void QrsDecter(float x)

float qrsfilter(float x);

float bpfilter(float x);
float diff(float x);
float smooth(float x);
int QrsDetect(int x);

#endif
//心率曲线