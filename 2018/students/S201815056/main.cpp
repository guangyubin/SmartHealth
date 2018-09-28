#include <stdio.h>
#include"QrsDetect.h"
void main()
{

	printf("hello world\n");

	FILE *fp = fopen("data//100.dat", "rb");
	if(fp==NULL)
	{
		printf("there is no files\n");
	    return;
	}
    FILE *fp1 = fopen("data//100_filt.dat", "wb");
    if(fp1==NULL)
	{
		printf("creat file error");
	    return;
	}
	short x;
    int pos=0;
	for(int i = 0;i <1000; i++)
	{
		fread(&x,sizeof(short),1,fp);
	    short y = 2*x;
		fwrite(&y , sizeof (short),1,fp1);
		printf("%d " , x);
		int res = QRSDetect(x);
			if(res ==1)
				printf("there is a qrs in %d samples");
	}
	fclose(fp);
	fclose(fp1);


}
