//
//  thresholdKernel.metal
//  Frame
//
//  Created by Max Berghaus on 06.02.23.
//

#include <metal_stdlib>
using namespace metal;

#include <CoreImage/CoreImage.h>

extern "C" {
    namespace coreimage {
        float4 ThresholdFilterKernel(sampler src, float threshold) {
            // 1
            float4 input = src.sample(src.coord());
            // 2
            float luma = dot(input.rgb, float3(0.2126, 0.7152, 0.0722));
            // 3
            float value = step(threshold, luma);
            // 4
            float3 rgb = float3(value);
            // 5
            return float4(rgb, input.a);
        }
    }
}
