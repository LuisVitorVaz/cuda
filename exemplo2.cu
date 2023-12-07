#include <iostream>
 const int N = 10;
 // Tamanho do vetor 
// Kernel para somar os elementos do vetor (uma única thread) 
__global__ void somaVetor(int *vetor, int *resultado) { 
if (threadIdx.x == 0) {
 for (int i = 0; i < N; ++i) { resultado[0] += vetor[i]; } 
    
} 
    
}

 int main() {
     
 const int tamanhoVetor = N; 
 int vetor[tamanhoVetor] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
 int resultado[1] = {0}; 
// A soma será armazenada aqui
 int *d_vetor, *d_resultado;
 // Aloca memória na GPU
 cudaMalloc((void**)&d_vetor, sizeof(int) * tamanhoVetor);
 cudaMalloc((void**)&d_resultado, sizeof(int)); 
// Copia dados do host para a GPU
 cudaMemcpy(d_vetor, vetor, sizeof(int) * tamanhoVetor, cudaMemcpyHostToDevice); 
// Chama o kernel com um bloco e uma única thread 
somaVetor<<<1, 1>>>(d_vetor, d_resultado); 
// Copia o resultado de volta para o host 
cudaMemcpy(resultado, d_resultado, sizeof(int), cudaMemcpyDeviceToHost);
 std::cout << "A soma dos elementos do vetor é: " << resultado[0] << std::endl;
 // Libera memória cudaFree(d_vetor); cudaFree(d_resultado); return 0;
 }
