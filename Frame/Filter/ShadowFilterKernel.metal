//
//  ShadowFilterKernel.metal
//  Frame
//
//  Created by Max Berghaus on 07.03.23.
//

#include <metal_stdlib>
using namespace metal;

#include <CoreImage/CoreImage.h>

extern "C" {
  namespace coreimage {
      
      float4 shadowFilterKernel (sampler src , float inputShadowFactor){
          float4 currentSource = sample (src, samplerCoord(src));
          float thresholdMin = 100.0;
          float thresholdMax = 0.0;
          
          float mittlerehelligkeit = (currentSource.r + currentSource.g + currentSource.b);
          
          if (mittlerehelligkeit <= thresholdMin && mittlerehelligkeit <= thresholdMax){
              currentSource.r = currentSource.r - inputShadowFactor;
              currentSource.g = currentSource.g - inputShadowFactor;
              currentSource.b = currentSource.b - inputShadowFactor;
          }
          
          
          return currentSource;
      }
        
    }
}
