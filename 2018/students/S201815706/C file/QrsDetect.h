//ͷ�ļ�������һЩ�궨�塢ȫ�ֱ������塢��������
#ifndef __QRS_DETECT_H__
#define __QRS_DERECT_H__
#define size  1000//�����СΪ1000
#define N 10//����ƽ���˲�����ƽ��ֵʱ��ȡ�ĵ���



float bpfilter(float x);
float diff(float x);
float smooth(float x);

int QrsDectet(int x);

#endif