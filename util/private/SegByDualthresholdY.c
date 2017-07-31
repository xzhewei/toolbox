
#include <math.h>
#include <stdio.h>
#include "mex.h"

// 通用参数
#define NULL 0

// 双阈值分割的配置参数
#define OMEGA 12
#define ALPHA 1
#define BETA 220
#define EPSILON 4
#define GAMMA 5
#define KAY 1.06

// 最大、最小值计算
#define max(a, b) ((a) > (b) ? (a) : (b))
#define min(a, b) ((a) < (b) ? (a) : (b))


void SegByDualthresholdY(unsigned char *pYIn, unsigned char *pYout, int height, int width)
{
	unsigned char Yd;
	unsigned char TL, TH, T1, T2, T3;
	int rows, cols, k, i;
	unsigned char Iij;
	unsigned char* ptrs = NULL;
	unsigned char* ptrd = NULL;
	unsigned char* ptrdcopy = NULL;
	int sum = 0;
	// for(int i=0;i<height;i+=1){
	// 	for(int j=0;j<width;j+=1){
	// 		printf("pYIn:[%d,%d]:%d\n",i,j,pYIn[i*width+j]);
	// 	}
	// }
	for (rows = 0; rows < height; rows += 2)
	{

		ptrs = &pYIn[rows*width];  //? 这个循环中没用到
		ptrd = &pYout[rows*width];

		for (cols = 0; cols < OMEGA + 1; cols++)
		{
			ptrd[cols] = 0;
		}

		for (cols = width - OMEGA; cols < width; cols++)
		{
			ptrd[cols] = 0;
		}
	}

	for (rows = 0; rows < height; rows += 2)
	{

		ptrs = &pYIn[rows*width];
		ptrd = &pYout[rows*width];

		sum = 0;

		for (k = 0; k < 2 * OMEGA + 1; k++) //？ 一个omega正方形窗口累加灰度值？
		{
			sum += ptrs[k];
		}

		for (cols = OMEGA + 1; cols < width - OMEGA; cols++) //？不是一行一个TL、TH么，这个看着像一列一个
		{
			sum += ptrs[cols + OMEGA];

			sum -= ptrs[cols - OMEGA - 1];

			TL = (unsigned char)(sum / 25 + ALPHA);
			T3 = max((unsigned char)(KAY * (TL - ALPHA)), TL + EPSILON);
			T2 = min(T3, TL + GAMMA);
			T1 = min(T2, BETA);
			TH = max(T1, TL);


			Iij = ptrs[cols];

			if (Iij > TH)
				Yd = 0xff;
			else if (Iij < TL)
				Yd = 0;
			else
				Yd = ptrd[cols - 1];


			ptrd[cols] = Yd;
		}


		ptrd = pYout + (rows + 1)*width;
		ptrdcopy = pYout + rows*width;

		for (i = 0; i < width; i++)
			ptrd[i] = ptrdcopy[i];
	}
}

void mexFunction(int nlhs, mxArray *plhs[],	int nrhs, const mxArray*prhs[])
{
	//SegByDualthresholdY(unsigned char *pYIn, unsigned char *pYout, int height, int width)
	unsigned char *mpYIn = (unsigned char *)mxGetPr(prhs[0]);
	unsigned char *mpYOut = (unsigned char *)mxGetPr(prhs[1]);
	printf("1.float converted.\n");
	int h = (int) mxGetScalar(prhs[2]);
	int w = (int) mxGetScalar(prhs[3]);
	printf("2.get height=%d and width=%d\n",h,w);
	unsigned char *pYIn = (unsigned char *)malloc(sizeof(unsigned char)* h * w);
	unsigned char *pYOut = (unsigned char *)malloc(sizeof(unsigned char)* h * w);
	printf("3.get \*pYInt and \*pYOut\n");
	plhs[0] = mxCreateDoubleMatrix(h, w, mxREAL);
	plhs[1] = mxCreateDoubleMatrix(h, w, mxREAL);
	double * rYIn = mxGetPr(plhs[0]);
	double * rYOut = mxGetPr(plhs[1]);
	mwSize hm = mxGetM(prhs[0]);
	mwSize wm = mxGetN(prhs[0]);
	printf("hm=%d,wm=%d",(int)hm,(int)wm);

	for(int i=0;i<h;i++){
		for(int j=0;j<w;j++){
			// printf("4. mpYIn:[%d,%d]:%d\n",i,j,mpYIn[i*w+j]);
			pYIn[i*w+j]=(unsigned char)mpYIn[i+j*h];   //matlab里矩阵是按列存储，c语言里数据是按行存储，实质上是转置
			// rYOut[i*w+j] = (double) mpYIn[i*w+j];
			// printf("7. rYOut:[%d,%d]:%f\n",i,j,rYOut[i*w+j]);
			// printf("5. pYIn:[%d,%d]:%d\n",i,j,pYIn[i*w+j]);
			//printf("6. mpYOut:[%d,%d]:%f\n",i,j,mpYOut[i*w+j]);
			//pYOut[i*w+j]=(unsigned char)mpYOut[i*w+j];
			//printf("7. pYOut:[%d,%d]:%f\n",i,j,pYOut[i*w+j]);
		}
	}
	SegByDualthresholdY(pYIn, pYOut, h, w); 
	// for(int i=0;i<h;i=i+2)
	// 	for(int j=0;j<w;j=j+2)
	// 		printf("6. pYOut:[%d,%d]:%d\n",i,j,pYOut[i*w+j]);

	for(int i=0;i<h;i++){
		for(int j=0;j<w;j++){
	// 		// if(pYOut[i*w+j]!=0)
	// 		// 	printf("6. pYOut:[%d,%d]:%d\n",i,j,pYOut[i*w+j]);
			rYIn[i+j*h] = (double) pYIn[i*w+j]; // 这里也需要转置，否则matlab获得的像素顺序是错误的
			rYOut[i+j*h] = (double) pYOut[i*w+j];
			// rYOut[i*w+j] = (double) pYOut[i*w+j];
	// 		// if(pYOut[i*w+j]!=0)
	// 		// 	printf("7. rYOut:[%d,%d]:%f\n",i,j,rYOut[i*w+j]);
		}
	}
}