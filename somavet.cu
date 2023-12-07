#include <cstdio>
#include <cstdlib>
#include<cstring>
 
__global__ void vecAdd( int *v1, int *v2, int *res ){
    int i = threadIdx.x;
    res[i] = v1[i] * v2[i];
}
 
// teste simples
 
int main( int argc, char **argv ){
    int array[]={2,4,6,8,10, 12,14,16,18,20};
    int array2[]={1,1,1,1,1, 1,1,1,1,1};
 
    int *cudaArr1, *cudaArr2, *resCuda;
 
    int res[10];
 
    //cudaMemCpy(  );
 
    cudaMalloc( (void**) &cudaArr1, 10 * sizeof(int));
    cudaMalloc( (void**) &cudaArr2, 10 * sizeof(int));
    cudaMalloc( (void**) &resCuda, 10 * sizeof(int));
 
    cudaMemcpy( cudaArr1, array, 10 * sizeof(int), cudaMemcpyHostToDevice );
    cudaMemcpy( cudaArr2, array2, 10 * sizeof(int), cudaMemcpyHostToDevice );
 
    vecAdd<<<1, 10>>>( cudaArr1, cudaArr2, resCuda );
 
    //cudaMemcpy( res, cudaArr1, 5* sizeof(int), cudaMemcpyDeviceToHost );
    cudaMemcpy( res, resCuda, 10* sizeof(int), cudaMemcpyDeviceToHost );
 
    for( int i = 0; i < 10; i++ ){
        printf( "%d ", res[i] );
    }
 
    puts("");
 
    return 0;
}
