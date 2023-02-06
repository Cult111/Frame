//
//  GrayscaleFilter.swift
//  Frame
//
//  Created by Max Berghaus on 16.01.23.
//

import Foundation
import CoreImage

class GrayscaleFilter: CIFilter {
    dynamic var inputImage: CIImage?
    
    static var kernel: CIColorKernel = { () -> CIColorKernel in
        let url = Bundle.main.url(forResource: "CustomFilterKernel",
                                  withExtension: "metallib")! //1
        let data = try! Data(contentsOf: url)
        return try! CIColorKernel(functionName: "grayscaleFilterKernel",
                                  fromMetalLibraryData: data) //2
    }()
    
    
    override var outputImage: CIImage? {
        guard let inputImage = inputImage else { return .none }
        return GrayscaleFilter.kernel.apply(extent: inputImage.extent,
                                            roiCallback: { (index, rect) -> CGRect in
            return rect
        }, arguments: [inputImage])
    }

    
}
