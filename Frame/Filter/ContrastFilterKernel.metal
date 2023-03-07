//
//  ContrastFilterKernal.metal
//  Frame
//
//  Created by Max Berghaus on 27.02.23.
//

#include <metal_stdlib>
using namespace metal;

#include <CoreImage/CoreImage.h>

extern "C" {
  namespace coreimage {
      
      float4 contrastFilterKernel (sampler src , float inputContrastFactor){
          float4 currentSource = sample (src, samplerCoord(src));
          
          float mittlerehelligkeit = (currentSource.r + currentSource.g + currentSource.b) / 3;
          
          float alpha = (255+inputContrastFactor)/(255-(inputContrastFactor));
          
          currentSource.r = alpha * (currentSource.r - mittlerehelligkeit) + mittlerehelligkeit;
          currentSource.g = alpha * (currentSource.g - mittlerehelligkeit) + mittlerehelligkeit;
          currentSource.b = alpha * (currentSource.b - mittlerehelligkeit) + mittlerehelligkeit;
          
          return currentSource;
      }
        
    }
}
