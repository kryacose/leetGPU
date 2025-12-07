// https://leetgpu.com/challenges/relu
#include <cuda_runtime.h>

__global__ void relu_kernel(const float* input, float* output, int N) {

    unsigned int id = blockIdx.x*blockDim.x + threadIdx.x;

    if(id < N) {
        const float& inp = input[id];
        float& outp = output[id];
        outp = inp > 0 ? inp : 0.0;
    }

}

// input, output are device pointers (i.e. pointers to memory on the GPU)
extern "C" void solve(const float* input, float* output, int N) {
    int threadsPerBlock = 256;
    int blocksPerGrid = (N + threadsPerBlock - 1) / threadsPerBlock;

    relu_kernel<<<blocksPerGrid, threadsPerBlock>>>(input, output, N);
    cudaDeviceSynchronize();
}
