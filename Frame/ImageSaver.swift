//
//  ImageSaver.swift
//  Frame
//
//  Created by Max Berghaus on 07.01.23.
//

import UIKit

class ImageSaver: NSObject{
    
    var successHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted( _ image: UIImage, didFinshSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error{
            errorHandler?(error)
        }else {
            successHandler?()
        }
    }
}
