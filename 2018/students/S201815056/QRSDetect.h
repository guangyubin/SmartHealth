#ifndef _QRS_DETECT_H_
#define _QRS_DETECT_H_

float qrsfilter(float x);

float bpfilter(float x);
float diff(float x);
float smooth(float x);



int QRSDetect(float x);
  



#endif
