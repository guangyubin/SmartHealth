//源文件里是一些函数定义（也有说是函数实现，总之就是函数的具体内容），和主函数。
#include<stdio.h>
#include"QrsDetect.h"


void main()
{
	printf("hello world!\n");
	FILE *fp =  fopen("C:\\Users\\guang\\Desktop\\SmartHealth\\2018\\data\\100.dat", "rb");
	FILE *fp1 = fopen("C:\\Users\\guang\\Desktop\\SmartHealth\\2018\\data\\100_filt.dat", "wb");
	FILE *fp2 = fopen("C:\\Users\\guang\\Desktop\\SmartHealth\\2018\\data\\100.txt", "w+");
	short x;
	int pos = 0;
	int i; 


	for ( i = 0; i < 20000; i++)
	{
		fread(&x, sizeof(short), 1, fp);

		short y = smooth(diff(bpfilter(x)));
		fwrite(&y, sizeof(short), 1, fp1);
		//	printf("%d",x);
		int res = QrsDectet(x);
		if (res == 1)
		{
			fprintf(fp2,"%d \n" ,i );
			printf("there is a qrs in samples  %d \n", i);
		}
	}

	
	fclose(fp);
	fclose(fp1);
	fclose(fp2);

}

// matlab code

/*              
//fid = fopen('C:\Users\guang\Desktop\SmartHealth\2018\data\100.dat', 'rb');
//d = fread(fid, inf, 'short');
//fclose(fid);
//
//fid = fopen('C:\Users\guang\Desktop\SmartHealth\2018\data\100_filt.dat', 'rb');
//d2 = fread(fid, inf, 'short');
//fclose(fid);
//figure;
//subplot(211); plot(d2);
//
//qrs = load('C:\Users\guang\Desktop\SmartHealth\2018\data\100.txt');
//
//subplot(212); plot(d2); hold on; plot(qrs, d2(qrs), '.r');
*/