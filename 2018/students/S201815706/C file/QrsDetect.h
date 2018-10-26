//头文件里面是一些宏定义、全局变量定义、函数声明
#ifndef __QRS_DETECT_H__
#define __QRS_DERECT_H__
#define size  1000//数组大小为1000
#define N 10//滑动平均滤波计算平均值时所取的点数



float bpfilter(float x);
float diff(float x);
float smooth(float x);

int QrsDectet(int x);

#endif