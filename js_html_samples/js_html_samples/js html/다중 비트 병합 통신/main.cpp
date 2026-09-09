#include <iostream>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>

/* run this program using the console pauser or add your own getch, system("pause") or input loop */

int main(int argc, char** argv) 
{
//     b[] 1   2   3   4   5
//32 22            1
//25 34 
	FILE * fpr = NULL;
	FILE * fpw = NULL;
	
	fpr = fopen("1.png", "rb");
	if(fpr == NULL)
	{
		printf("read open fail\n");
		return 0;
	}
	
	fpw = fopen("1.txt", "wb");
	if(fpw == NULL)
	{
		printf("write open fail\n");
		return 0;
	}


while(1)
{
	//
	int e = feof(fpr);
	if( e != 0)
	{
		printf("read end\n");
		return 0;
	}
	
	//	
	unsigned char buf[8];
	memset(&buf[0], 0x00, 8);

	//
	fread(&buf[0], 1, 8, fpr);

	//
	unsigned char a[16];
	unsigned char b[8][16];
	unsigned char c = 0x1;

	memset(&b[0][0], 0x00, 8*16);

	memcpy(&a[0], &buf[0], 16);
	
	
	int i;
	int j;
	
		for(j=0; j<8; j++)
		{
			unsigned char x;
//	printf("%2d ", a[j]);
		}
//	printf("\n");
		
	for(i=0; i<4; i++)
	{
		unsigned char v = 0x0;
		for(j=0; j<8; j++)
		{
			char t[3];
			int a = (buf[i] >> j) & 0x1;
			int b = (buf[4+i] >> j) & 0x1;
			if((a == 0) & (b== 0))
			{
				t[0] = '0';
//				fwrite(&t[0], 1, 1, fpw);
				v = v << 0x1;
				v = v | 0x00;
			}
			if((a == 1) & (b== 1))
			{
				t[0] = '1';
//				fwrite(&t[0], 1, 1, fpw);
				v = v << 0x1;
				v = v | 0x01;
			}
			if((a == 0) & (b== 1))
			{
				t[0] = ' ';
				t[1] = '1';
//				fwrite(&t[0], 1, 2, fpw);
				char tmp = '\n';
				fwrite(&tmp, 1, 1, fpw);
			}
			if((a == 1) & (b== 0))
			{
				t[0] = '1';
				t[1] = ' ';
//				fwrite(&t[0], 1, 2, fpw);
				char tmp = '\n';
				fwrite(&tmp, 1, 1, fpw);
			}
			fwrite(&v, 1, 1, fpw);
		}
		char tmp = '\n';
		fwrite(&tmp, 1, 1, fpw);
	}
	
//	fwrite(&b[0][0], 1, 8*16, fpw);

	char tmp = '\n';
	fwrite(&tmp, 1, 1, fpw);
}
	
	fclose(fpr);
	fclose(fpw);
	
	return 0;
}
