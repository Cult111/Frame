//
//  ThresholdFilter.swift
//  Frame
//
//  Created by Max Berghaus on 06.02.23.
//

import Foundation
import CoreImage


class ThresholdFilter: CIFilter {
  private lazy var kernel: CIKernel = {
    guard let url = Bundle.main.url(forResource: "default", withExtension: "metallib"), let data = try? Data(contentsOf: url) else {
      fatalError("Unable to load metallib")
    }
    
    let name = "ThresholdFilterKernel"
    guard let kernel = try? CIKernel(functionName: name, fromMetalLibraryData: data) else { fatalError("Unable to create the CIColorKernel for filter \(name)") }
    
    return kernel
  }()
  
  var inputImage: CIImage?
  var threshold: Float = 0.5
  override var outputImage: CIImage? {
    guard let inputImage = inputImage else { return .none }
    return kernel.apply(
      extent: inputImage.extent,
      roiCallback: {(index, rect) -> CGRect in return rect},
      arguments: [inputImage, threshold]
    )
  }
}
