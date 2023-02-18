//
//  GrayscaleFilter.swift
//  Frame
//
//  Created by Max Berghaus on 16.01.23.
//

import Foundation
import CoreImage

class GrayscaleFilter: CIFilter {
    private lazy var kernel: CIKernel = {
        guard let url = Bundle.main.url(forResource: "default", withExtension: "metallib"), let data = try? Data(contentsOf: url) else {
            fatalError("Unable to load metallib")
        }
        
        let name = "grayscaleFilterKernel"
        guard let kernel = try? CIKernel(functionName: name, fromMetalLibraryData: data) else { fatalError("Unable to create the CIColorKernel for filter \(name)") }
        
        return kernel
    }()
    
    var inputImage: CIImage?
    override var outputImage: CIImage? {
        guard let inputImage = inputImage else { return .none }
        return kernel.apply(
            extent: inputImage.extent,
            roiCallback: {(index, rect) -> CGRect in return rect},
            arguments: [inputImage]
        )
    }
}
