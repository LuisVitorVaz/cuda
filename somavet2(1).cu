#include <stdio.h>

// Device code
__global__ void VecAdd(float *A, float* B, float* C, int n){
     int i =blockIdx.x; 
     if (i < n)
         C[i] = A[i] + B[i];
}

// Host code
int main()	{
int n =700;
size_t size = n * sizeof(float); 
float *d_A, *d_B, *d_C;
float h_A[n] ;
float h_B[n] ;
float h_C[n] ;

cudaMalloc((void**)&d_A, size);
cudaMalloc((void**)&d_B, size);
cudaMalloc((void**)&d_C, size);
/*
float h_A[] = {1,2,3,4,5};
float h_B[] = {10,20,30,40,50};
float h_C[] = {0,0,0,0,0};
*/
for (int i = 0; i<n; i++) {
    h_A[i] = 1;
    h_B[i] = 1;
    h_C[i] = 0;
}

cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);

int nThreadsPerBlock	= 1;
int nBlocks	= n ; //n /nThreadsPerBlock;

VecAdd<<<nBlocks, nThreadsPerBlock>>>(d_A, d_B, d_C, n);

cudaMemcpy(h_C, d_C, size,cudaMemcpyDeviceToHost);	


printf ("Vetor resultado: \n") ;

for (int i = 0; i<n-1; i++) {
    printf ("%.0f ", h_C[i]) ;
}

h_C[n] = 555 ;

printf ("Valor ultimo elemento: %.0f\n", h_C[n]) ;

cudaFree(d_B);
cudaFree(d_C);
}
