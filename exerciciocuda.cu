#include <iostream>
#include <cuda_runtime.h>

const int N = 1000; // Tamanho dos vetores
__device__ int somaValores2(int a, int b){
    return a+b;
}
__device__ int mult(int a, int b){
    return a*b;
}
// Kernel para a soma de dois vetores
__global__ void somaVetores(const int *a, const int *b, int *resultado) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < N) {
        resultado[i] = somaValores2(a[i],  b[i]);
        resultado[i] = mult(a[i],  resultado[i]);
    }
}

int main() {
    // Inicializa os vetores no host
    int vetorA[N], vetorB[N], resultado[N];

    for (int i = 0; i < N; ++i) {
        vetorA[i] = i;
        vetorB[i] = 2 * i;
    }

    // Aloca memória na GPU
    int *d_vetorA, *d_vetorB, *d_resultado;
    cudaMalloc((void**)&d_vetorA, sizeof(int) * N);
    cudaMalloc((void**)&d_vetorB, sizeof(int) * N);
    cudaMalloc((void**)&d_resultado, sizeof(int) * N);

    // Copia os dados do host para a GPU
    cudaMemcpy(d_vetorA, vetorA, sizeof(int) * N, cudaMemcpyHostToDevice);
    cudaMemcpy(d_vetorB, vetorB, sizeof(int) * N, cudaMemcpyHostToDevice);

    // Define a configuração do lançamento do kernel
    int threadsPorBloco = 256;
    int blocos = (N + threadsPorBloco - 1) / threadsPorBloco;

    // Chama o kernel para a soma dos vetores
    somaVetores<<<blocos, threadsPorBloco>>>(d_vetorA, d_vetorB, d_resultado);

    // Copia o resultado de volta para o host
    cudaMemcpy(resultado, d_resultado, sizeof(int) * N, cudaMemcpyDeviceToHost);

    // Exibe alguns resultados
    std::cout << "Alguns resultados da soma dos vetores:\n";
    for (int i = 0; i < N; ++i) {
        std::cout << resultado[i] << " ";
    }
    std::cout << std::endl;

    // Libera memória na GPU
    cudaFree(d_vetorA);
    cudaFree(d_vetorB);
    cudaFree(d_resultado);

    return 0;
}
