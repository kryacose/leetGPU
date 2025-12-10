// https://leetgpu.com/challenges/swish-gated-linear-unit
#include <cuda_runtime.h>

__global__ void swiglu_kernel(const float* input, float* output, int halfN) {
    unsigned int tid = blockIdx.x * blockDim.x + threadIdx.x;

    if(tid < halfN) {
        output[tid] = input[tid + halfN] * (input[tid] / (1 + __expf(-input[tid])));
    }
}

// input, output are device pointers
extern "C" void solve(const float* input, float* output, int N) {
    int halfN = N / 2;
    int threadsPerBlock = 256;
    int blocksPerGrid = (halfN + threadsPerBlock - 1) / threadsPerBlock;

    swiglu_kernel<<<blocksPerGrid, threadsPerBlock>>>(input, output, halfN);
    cudaDeviceSynchronize();
}