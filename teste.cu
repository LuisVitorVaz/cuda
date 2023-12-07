#include <cstdio>
#include <cstdlib>
#include<cstring>
 
    
#define N 10;
    
__global__ void vector_add(float *out, float *a, float *b, int n) {
    for(int i = 0; i < n; i++){
        out[i] = a[i] + b[i];
}
        }

int main( int argc, char **argv ){
    float *a, *b, *out; 

    // Allocate memory
    int vet1[10];
    int vet2[10];
    int res[10];
    a   = (float*)malloc(sizeof(float) * 10);
    b   = (float*)malloc(sizeof(float) * 10);
    out = (float*)malloc(sizeof(float) * 10);

    
    // Initialize array
    for(int i = 0; i < 10; i++){
        vet1[i] = 1.0f; vet2[i] = 2.0f;
    }
    
    cudaMalloc( (void**) &a, 10 * sizeof(float));
    cudaMalloc( (void**) &b, 10 * sizeof(float));
    cudaMalloc( (void**) &out, 10 * sizeof(float));
 
    cudaMemcpy( a,vet1, 10 * sizeof(int), cudaMemcpyHostToDevice );
    cudaMemcpy( b,vet2, 10 * sizeof(int), cudaMemcpyHostToDevice );
        
    vector_add<<<1, 10>>>( out, a, b, 10 );
    
     cudaMemcpy( res, out, 10 * sizeof(int), cudaMemcpyDeviceToHost );
     
    for(int i = 0; i < 10; i++ ){
        printf( "%d ", res[i] );
    }
 
    puts("");
 
    return 0;

}
