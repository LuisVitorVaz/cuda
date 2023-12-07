#include <stdio.h>

// Função definida pelo programador que será chamada no kernel
__device__ int minhaFuncaoGPU(int a, int b) {
    return a + b;
}

// Kernel CUDA: Chama a função na GPU
__global__ void meuKernel(int *resultado) {
    int threadId = threadIdx.x;
    int blocoId = blockIdx.x;

    // Chamando a função na GPU
    resultado[threadId] = minhaFuncaoGPU(threadId, blocoId);
}

int main() {
    const int tamanho = 10;
    int resultado[tamanho];

    int *d_resultado;  // Ponteiro para o resultado no device

    // Aloca memória no device
    cudaMalloc((void**)&d_resultado, tamanho * sizeof(int));

    // Configuração de lançamento do kernel
    dim3 blocos(1);
    dim3 threads(tamanho);

    // Chama o kernel no device
    meuKernel<<<blocos, threads>>>(d_resultado);

    // Copia os resultados do device para o host
    cudaMemcpy(resultado, d_resultado, tamanho * sizeof(int), cudaMemcpyDeviceToHost);

    // Imprime os resultados
    printf("Resultados:\n");
    for (int i = 0; i < tamanho; ++i) {
        printf("%d\n", resultado[i]);
    }

    // Libera a memória alocada no device
    cudaFree(d_resultado);

    return 0;
}
