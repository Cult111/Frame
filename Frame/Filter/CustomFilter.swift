//
//  CustomFilter.swift
//  Frame
//
//  Created by Max Berghaus on 24.01.23.
//

import Foundation
import CoreImage

class CustomFilter: CIFilter {
   
    dynamic var inputImage: CIImage?
        var inputBrightnessFactor:Float = 1

        override var attributes: [String : Any] {
            return [
                kCIAttributeFilterDisplayName: "My Custom Filter",

                "inputImage": [kCIAttributeIdentity: 0,
                               kCIAttributeClass: "CIImage",
                               kCIAttributeDisplayName: "Image",
                               kCIAttributeType: kCIAttributeTypeImage],

                "inputBrightnessFactor": [kCIAttributeIdentity: 0,
                                          kCIAttributeClass: "NSNumber",
                                          kCIAttributeDisplayName: "Brightness Factor",
                                          kCIAttributeDefault: 0,
                                          kCIAttributeMin: 0,
                                          kCIAttributeSliderMin: 0,
                                          kCIAttributeSliderMax: 1,
                                          kCIAttributeType: kCIAttributeTypeScalar]
            ]
        }

    static var kernel: CIColorKernel = { () -> CIColorKernel in
        let url = Bundle.main.url(forResource: "default",
                                  withExtension: "metallib")! //1
        let data = try! Data(contentsOf: url)
        return try! CIColorKernel(functionName: "customFilterKernel",
                                  fromMetalLibraryData: data) //2
    }()
    
        override init() {
            super.init()
        }

        override func setValue(_ value: Any?, forKey key: String) {
            switch key {
                case "inputImage":
                inputImage = (value as! CIImage)
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
            return CustomFilter.kernel.apply(extent: inputImage.extent, arguments: [inputImage as Any, inputBrightnessFactor as Any])!
        }
    }

