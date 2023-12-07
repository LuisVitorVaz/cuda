#include <iostream>

const int N = 1024;  // Tamanho do vetor

// Kernel para somar os elementos do vetor

__global__ void somaVetor(int *vetor, int *resultado) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;

    // Cada thread soma um par de elementos adjacentes
    if (idx < N) {
        resultado[idx] = vetor[idx];
    }
}

int main() {
    const int tamanhoVetor = N; //e 10
    int vetor[tamanhoVetor] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    int resultado[tamanhoVetor];


    int *d_vetor, *d_resultado;

    // Aloca memória na GPU
    cudaMalloc((void**)&d_vetor, sizeof(int) * tamanhoVetor);
    cudaMalloc((void**)&d_resultado, sizeof(int) * tamanhoVetor);

    // Copia dados do host para a GPU
    cudaMemcpy(d_vetor, vetor, sizeof(int) * tamanhoVetor, cudaMemcpyHostToDevice);

    // Chama o kernel com um bloco e threads por bloco suficientes
    somaVetor<<<1, tamanhoVetor>>>(d_vetor, d_resultado);//<<<1,1>>> primeiro o bloco depois a thread

    // Copia o resultado de volta para o host
    cudaMemcpy(resultado, d_resultado, sizeof(int) * tamanhoVetor, cudaMemcpyDeviceToHost);

    // Soma final no host
    int resultadoFinal = 0;
    for (int i = 0; i < tamanhoVetor; ++i) {
        resultadoFinal += resultado[i];
    }

    std::cout << "A soma dos elementos nesse  vetor é: " << resultadoFinal << std::endl;
    // Libera memória
    cudaFree(d_vetor);
    cudaFree(d_resultado);

    return 0;
}
