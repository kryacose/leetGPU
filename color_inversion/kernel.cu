// https://leetgpu.com/challenges/color-inversion
#include <cuda_runtime.h>

__global__ void invert_kernel(unsigned char* image, int width, int height) {

    int index = (blockIdx.x * blockDim.x + threadIdx.x) * 4;

    if(index < width*height*4) {
        image[index] = 255-image[index];
        image[index+1] = 255-image[index+1];
        image[index+2] = 255-image[index+2];
        // image[index+3] = 255-image[index+3];
    }

}
// image_input, image_output are device pointers (i.e. pointers to memory on the GPU)
extern "C" void solve(unsigned char* image, int width, int height) {
    int threadsPerBlock = 256;
    int blocksPerGrid = (width * height + threadsPerBlock - 1) / threadsPerBlock;

    invert_kernel<<<blocksPerGrid, threadsPerBlock>>>(image, width, height);
    cudaDeviceSynchronize();
}