//ͷ�ļ�������һЩ�궨�塢ȫ�ֱ������塢��������
#ifndef __1_QRS_DETECT_H__
#define __1_QRS_DERECT_H__
//#include<stdio.h>
#define size  1000//�����СΪ1000
#define N 10//����ƽ���˲�����ƽ��ֵʱ��ȡ�ĵ���

//void QrsDecter(float x)

float qrsfilter(float x);

float bpfilter(float x);
float diff(float x);
float smooth(float x);
int QrsDetect(int x);

#endif
//��������