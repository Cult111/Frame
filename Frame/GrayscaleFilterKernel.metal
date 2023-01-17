//
//  GrayscaleFilterKernel.metal
//  Frame
//
//  Created by Max Berghaus on 16.01.23.
//

#include <metal_stdlib>
using namespace metal;

#include <CoreImage/CoreImage.h>

extern "C" {
  namespace coreimage {
    // KERNEL GOES HERE
      float4 grayscaleFilterKernel(sample_t s) { //1
        float gray = (s.r + s.g + s.b) / 3;      //2
        return float4(gray, gray, gray, s.a);    //3
      }
  }
}
