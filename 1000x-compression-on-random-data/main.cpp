#include <iostream>
#include <cstdlib>
#include <ctime>
#include <memory.h>
#include <string.h>
#include <math.h>

using namespace std;





//
int data;
unsigned char rand_data[10];
unsigned char buf;


// 8개의 랜덤값을 중복 안되도록 모아서 압축에 사용한다.

int fn_rand_length()
{
	//
	int count1 = 0;
	int count2 = 0;
	int count3 = 0;
	int count4 = 0;
	int count5 = 0;
	int count6 = 0;
	int count7 = 0;
	int count8 = 0;

	//
	unsigned char vv[10];
	char order[10];

	//
	count1 = 0;
	count2 = 0;
	count3 = 0;
	count4 = 0;
	count5 = 0;
	count6 = 0;
	count7 = 0;
	count8 = 0;

	//
	memset(&order[0], 0x00, 10);
	memset(&vv[0], 0x00, 10);
	memset(&rand_data[0], 0x00, 10);

	//
	int i = 0;
	i = 0;

	//
	while (1)
	{
		data = rand() % 8;


		if (data == 0 && count1 == 0)
		{
			if ((buf >> 7) & 0x1 == 1)
			{
				data = '7';
				vv[i] = data;
			}
			else
			{
				data = '7';
				vv[i] = data;
			}

			data = '0';	count1++;
			order[i] = '0'; i++;
			//printf("[     ] 111111111111 \n  ");
		}
		else if (data == 1 && count2 == 0)
		{

			if ((buf >> 6) & 0x1 == 1)
			{
				data = '6';
				vv[i] = data;
			}
			else
			{
				data = '6';
				vv[i] = data;
			}

			data = '1';	count2++;
			order[i] = '1'; i++;
			//printf("[     ] 2222222222222 \n  ");
		}
		else if (data == 2 && count3 == 0)
		{

			if ((buf >> 5) & 0x1 == 1)
			{
				data = '5';
				vv[i] = data;
			}
			else
			{
				data = '5';
				vv[i] = data;
			}

			data = '2';	count3++;
			order[i] = '2'; i++;
			//printf("[     ] 333333333333333 \n  ");
		}
		else if (data == 3 && count4 == 0)
		{

			if ((buf >> 4) & 0x1 == 1)
			{
				data = '4';
				vv[i] = data;
			}
			else
			{
				data = '4';
				vv[i] = data;
			}

			data = '3';	count4++;
			order[i] = '3'; i++;
			//printf("[     ] 44444444444 \n  ");
		}
		else if (data == 4 && count5 == 0)
		{

			if ((buf >> 3) & 0x1 == 1)
			{
				data = '3';
				vv[i] = data;
			}
			else
			{
				data = '3';
				vv[i] = data;
			}

			data = '4';	count5++;
			order[i] = '4'; i++;
			//printf("[     ] 5555555555 \n  ");
		}
		else if (data == 5 && count6 == 0)
		{

			if ((buf >> 2) & 0x1 == 1)
			{
				data = '2';
				vv[i] = data;
			}
			else
			{
				data = '2';
				vv[i] = data;
			}

			data = '5';	count6++;
			order[i] = '5'; i++;
			//printf("[     ] 6666666666 \n  ");
		}
		else if (data == 6 && count7 == 0)
		{

			if ((buf >> 1) & 0x1 == 1)
			{
				data = '1';
				vv[i] = data;
			}
			else
			{
				data = '1';
				vv[i] = data;
			}

			data = '6';	count7++;
			order[i] = '6'; i++;
			//printf("[     ]  777777777777777 \n ");
		}
		else if (data == 7 && count8 == 0)
		{

			if ((buf >> 0) & 0x1 == 1)
			{
				data = '0';
				vv[i] = data;
			}
			else
			{
				data = '0';
				vv[i] = data;
			}

			data = '7';	count8++;
			order[i] = '7'; i++;
			//printf("[     ]  8888888888 \n ");
		}


		if (count1 > 0 && count2 > 0 && count3 > 0 && count4 > 0 && count5 > 0 && count6 > 0 && count7 > 0 && count8 > 0)
		{
			count1 = 0;
			count2 = 0;
			count3 = 0;
			count4 = 0;
			count5 = 0;
			count6 = 0;
			count7 = 0;
			count8 = 0;
			//printf("[     ]  xxxxxxxxxxxxxxxxxx \n ");


/*
		//-----------------------------------------------------------------
		//실패
		//압축효율 5%  6MB -> 54MB -> 2.7MB
		//-----------------------------------------------------------------
		for(i=0; i<8; i++) //테스트 코드
		{
			fwrite(&order[i], 1, 1, fp); //원본.

			//같은 번호 순서
			if(order[i]-48 == i )
			{
				char order2 = order[0]-48;

				if( (buf >> i) & 0x1 )
				{
					order[i] = order[i] + order[i]-48;
					fwrite(&order[i], 1, 1, fp); //추가된 비트값
				}
				else
				{
					order[i] = order[i] - order2;
					fwrite(&order[i], 1, 1, fp); //제거된 비트값
				}

			}
		}
*/
			break;
		}

	}
	//printf("[     ]  eeeeeeeeeeee \n ");

	//갯수
	strcpy((char*)& rand_data[0], (char*)vv);
	int rcount = strlen((char*)vv);
	return rcount;
}









/* run this program using the console pauser or add your own getch, system("pause") or input loop */

int main(int argc, char** argv) 
{
	srand((unsigned int)time(NULL));
	
	
	FILE * fpr = NULL;
	FILE * fpw = NULL;
	fpr = fopen("1.exe","rb");
	fpw = fopen("test.txt","wt");
	int cnt = 0;
	
	
	
	while(1)
	{
		fn_rand_length();
//		t = rand_data[0]-'0';
//		char data = rand_data[0];

		fwrite(&rand_data[0], 1, 6, fpw);
		
	}
	
	
	while(1)
	{
		const int MAX = 1024;
		unsigned char buf[MAX];
		char arr[4][4];
		memset(&arr[0][0],0x00,16);
		
		int n = fread(&buf[0], 1, 1, fpr);
		if(n == -1) break;
		
		
		double r = pow(rand() % 8 * rand() % 8 * rand() % 8, 2) + rand() % 8;
		printf("%.2f\n",r);
		
		
		buf[0] = buf[0] >> 4;
//		printf("%d\n", buf[0]);
		if( buf[0] == 0 ){	arr[0][0] = '1';	}
		if( buf[0] == 1 ){	arr[0][1] = '1';	}
		if( buf[0] == 2 ){	arr[0][2] = '1';	}
		if( buf[0] == 3 ){	arr[0][3] = '1';	}

		if( buf[0] == 4 ){	arr[1][0] = '1';	}
		if( buf[0] == 5 ){	arr[1][1] = '1';	}
		if( buf[0] == 6 ){	arr[1][2] = '1';	}
		if( buf[0] == 7 ){	arr[1][3] = '1';	}

		if( buf[0] == 8 ){	arr[2][0] = '1';	}
		if( buf[0] == 9 ){	arr[2][1] = '1';	}
		if( buf[0] == 10 ){	arr[2][2] = '1';	}
		if( buf[0] == 11 ){	arr[2][3] = '1';	}

		if( buf[0] == 12 ){	arr[3][0] = '1';	}
		if( buf[0] == 13 ){	arr[3][1] = '1';	}
		if( buf[0] == 14 ){	arr[3][2] = '1';	}
		if( buf[0] == 15 ){	arr[3][3] = '1';	}


//		n = rand()%MAX;
//		buf[n] = '0';
		fwrite(&arr[0][0], 1, 4, fpw);
//		fwrite('\n', 1, 1, fpw);

		buf[0] = '\n';
		fwrite(&buf[0], 1, 1, fpw);

		fwrite(&arr[1][0], 1, 4, fpw);
		fwrite(&buf[0], 1, 1, fpw);
		
		fwrite(&arr[2][0], 1, 4, fpw);
		fwrite(&buf[0], 1, 1, fpw);

		fwrite(&arr[3][0], 1, 4, fpw);
		fwrite(&buf[0], 1, 1, fpw);

//		if(cnt > 1000000) break;
//		cnt++;
	}
	fclose(fpr);
	fclose(fpw);
	
//	system("notepad.exe test.txt");
	return 0;
}




















#if 0



void CtestDlg::OnBnClickedButton3()
{
	// TODO: 여기에 컨트롤 알림 처리기 코드를 추가합니다.

	FILE* fpr;
	fpr = fopen("test.bmp", "rb");
	FILE* fp;
	fp = fopen("test.txt", "wt");
	FILE* fp2;
	fp2 = fopen("test2.txt", "wb");
	FILE* fp3;
	fp3 = fopen("test3.txt", "wb");

	char* mem;
	mem = (char*)malloc(10000000);
	memset(mem, 0x00, 10000000);
	
	srand(time(NULL));
	char buf[100] = { "22" };
	long cnt = 0;
	while (1)
	{
		unsigned char data;
		int e;
		int i;
		for (i = 0; i < 6; i++)
		{
			e = fread(&data, 1, 1, fpr);
			buf[i] = data;
		}
		if (e == 0) break;
		int len = strlen(buf);

		long l = atol(buf);

		if (l == 0)
		{
			data = l;
//			fwrite(&data, 1, 1, fp3);
			continue;
		}
		else
		{
			data = ' ';
//			fwrite(&data, 1, 1, fp3);
		}


//		long r = pow(rand() % 8 * rand() % 8 * rand() % 8, 2) + rand() % 8 + rand() % 8;
		long r=0;
		int x;
		for (x = 0; x < 32; x++)
		{
			int t = 0;;
			char data;
			t = rand() % 8;		//보통
			data = t + '0';

//			fn_rand_length();	//느림
//			t = rand_data[x]-'0';
//			data = rand_data[x];

			fwrite(&data, 1, 1, fp3);

			if (t == 0) t = 2;
			r += t*x;
		}
		cnt++;

		l = l - r;

//		if (r < l)	l = l - r;
		//	l = l + rand()%8+rand()%8;
		//	printf("%d\n", l);

//		TRACE("[] %ld %ld \n", l, r);

		//중복된값.
		char m = *(mem + l + 100000);
		if (m == '0')
		{
			TRACE("중복된값\n");
			continue;
		}

		*(mem+l+1000000) = '0';
	}

	int i;
	for (i = 0; i < 10000000; i++)
	{
		char data = *(mem+i);
		fwrite(&data, 1, 1, fp);
	}
	delete mem;

	printf("\n");
	fclose(fpr);
	fclose(fp);
	fclose(fp2);
	fclose(fp3);

	system("\"C:\\Program Files\\7-Zip\\7z.exe\" a test.7z test.txt");
	system("\"C:\\Program Files\\7-Zip\\7z.exe\" a test2.7z test2.txt");
	system("\"C:\\Program Files\\7-Zip\\7z.exe\" a test3.7z test3.txt");

}


#include <deque>

using namespace std;

void CtestDlg::OnBnClickedButton4()
{
	// TODO: 여기에 컨트롤 알림 처리기 코드를 추가합니다.

	deque<long> dq;

	FILE* fpr;
	fpr = fopen("test.bmp", "rb");
	FILE* fp;
	fp = fopen("test.txt", "wt");
	FILE* fp2;
	fp2 = fopen("test2.txt", "wb");
	FILE* fp3;
	fp3 = fopen("test3.txt", "wb");

	char* mem;
	mem = (char*)malloc(10000000);
	memset(mem, 0x00, 10000000);

	srand(time(NULL));
	char buf[100] = { "22" };
	long cnt = 0;
	long tmp = 0;
	while (1)
	{
		unsigned char data;
		int e;
		int i;
		for (i = 0; i < 6; i++)
		{
			e = fread(&data, 1, 1, fpr);
			buf[i] = data;
		}
		if (e == 0) break;
		int len = strlen(buf);

		long l = atol(buf);
		/*
				if (l == 0)
				{
					data = l;
		//			fwrite(&data, 1, 1, fp3);
					continue;
				}
				else
				{
					data = ' ';
		//			fwrite(&data, 1, 1, fp3);
				}
		*/
		int r = pow(rand() % 8 * rand() % 8 * rand() % 8, 2) + rand() % 8;
		if (r < l)	l = l - r;
		//	l = l + rand()%8+rand()%8;
		//	printf("%d\n", l);

		if (l < tmp)
		{
			dq.push_front(cnt);
		}
		else
		{
			dq.push_back(cnt);
		}
		cnt++;

		tmp = l;

		*(mem + l + 1000000) = '0';
	}

	int i;
	for (i = 0; i < 10000000; i++)
	{
		char data = mem[i];
		fwrite(&data, 1, 1, fp);
	}
	for (i = 0; i < dq.size(); i++)
	{
		long l = dq[i];
		sprintf(&buf[0], "%d", l);
//		fwrite(&data, 1, 1, fp2);

		int k;
		for (k = 0; k < 6; k++)
		{
			char data = buf[k];
			fwrite(&data, 1, 1, fp2);
		}
		char data = ' ';
		fwrite(&data, 1, 1, fp2);
	}
	delete mem;

	printf("\n");
	fclose(fpr);
	fclose(fp);
	fclose(fp2);
	fclose(fp3);

	system("\"C:\\Program Files\\7-Zip\\7z.exe\" a test.7z test.txt");
	system("\"C:\\Program Files\\7-Zip\\7z.exe\" a test2.7z test2.txt");
	system("\"C:\\Program Files\\7-Zip\\7z.exe\" a test3.7z test3.txt");
}
#endif

