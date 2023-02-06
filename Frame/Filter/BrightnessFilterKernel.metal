//
//  CoustomFilterKernel.metal
//  Frame
//
//  Created by Max Berghaus on 24.01.23.
//

#include <metal_stdlib>
using namespace metal;

#include <CoreImage/CoreImage.h>

extern "C" {
  namespace coreimage {
      
      float4 brightnessFilterKernel (sampler src , float inputBrightnessFactor){
          float4 currentSource = sample (src, samplerCoord(src));
          
//          float4 input = src.sample(src.coord());
          
          currentSource.rgb = currentSource.rgb + inputBrightnessFactor * currentSource.a;
//          float3 rgb = input.rgb * inputBrightnessFactor;
          
          return currentSource;
      }
        
    }
}
