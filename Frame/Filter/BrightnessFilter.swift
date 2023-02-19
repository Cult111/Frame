//
//  CustomFilterTmp.swift
//  Frame
//
//  Created by Max Berghaus on 06.02.23.
//

import Foundation
import CoreImage


class BrightnessFilter: CIFilter {
    private lazy var kernel: CIKernel = {
      guard let url = Bundle.main.url(forResource: "default", withExtension: "metallib"), let data = try? Data(contentsOf: url) else {
        fatalError("Unable to load metallib")
      }
      
      let name = "brightnessFilterKernel"
      guard let kernel = try? CIKernel(functionName: name, fromMetalLibraryData: data) else { fatalError("Unable to create the CIColorKernel for filter \(name)") }
      
      return kernel
    }()

    
    var inputImage: CIImage?
    var inputBrightnessFactor: Float = 0.5
    
    override var attributes: [String : Any] {
        return [
            kCIAttributeFilterDisplayName: "BrightnessFilter",

            "inputImage": [kCIAttributeIdentity: 0,
                           kCIAttributeClass: "CIImage",
                           kCIAttributeDisplayName: "Image",
                           kCIAttributeType: kCIAttributeTypeImage],

            "inputBrightnessFactor": [kCIAttributeIdentity: 0,
                                      kCIAttributeClass: "NSNumber",
                                      kCIAttributeDisplayName: "Brightness Factor",
                                      kCIAttributeDefault: 0,
                                      kCIAttributeMin: 0,
                                      kCIAttributeSliderMin: -1,
                                      kCIAttributeSliderMax: 1,
                                      kCIAttributeType: kCIAttributeTypeScalar]
        ]
    }
    
    override init() {
        super.init()
    }

    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
            case "inputImage":
            inputImage = value as? CIImage
            case "inputBrightnessFactor":
                inputBrightnessFactor = value as! Float
            default:
                break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override var outputImage: CIImage? {
      guard let inputImage = inputImage else { return .none }
        return kernel.apply(
        extent: inputImage.extent,
        roiCallback: {(index, rect) -> CGRect in return rect},
        arguments: [inputImage, inputBrightnessFactor]
      )
    }
}

