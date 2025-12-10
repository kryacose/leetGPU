// https://leetgpu.com/challenges/count-2d-array-element
#include <cuda_runtime.h>
#include <cstdio>

__global__ void count_equal_kernel(const int* input, int* output, int N, int K) {
    int tid = (threadIdx.x + blockDim.x * blockIdx.x);
    int sum = 0;
    int total_threads = blockDim.x * gridDim.x;

    if (tid < N){
        while(tid < N) {
            if(input[tid] == K) sum +=1;
            tid += total_threads;
        }

        if(sum > 0) atomicAdd(output, sum);
    }
}

// input, output are device pointers (i.e. pointers to memory on the GPU)
extern "C" void solve(const int* input, int* output, int N, int M, int K) {
    int threadsPerBlock = 256;
    int blocksPerGrid = (N * M + threadsPerBlock * 16 - 1) / threadsPerBlock / 16;

    count_equal_kernel<<<blocksPerGrid, threadsPerBlock>>>(input, output, N * M, K);
    cudaDeviceSynchronize();
}