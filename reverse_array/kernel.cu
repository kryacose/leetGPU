// https://leetgpu.com/challenges/reverse-array
#include <cuda_runtime.h>

__global__ void reverse_array(float* input, int N) {

    int id = blockIdx.x*blockDim.x + threadIdx.x;

    if(id < N/2) {
        float a = input[id];
        float b = input[N - 1 - id];

        input[N - 1 - id] = a;
        input[id] = b;
    }

}

// input is device pointer
extern "C" void solve(float* input, int N) {
    int threadsPerBlock = 262144;
    int blocksPerGrid = (N + threadsPerBlock - 1) / threadsPerBlock;

    reverse_array<<<blocksPerGrid, threadsPerBlock>>>(input, N);
    cudaDeviceSynchronize();
}