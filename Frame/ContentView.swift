//
//  ContentView.swift
//  Frame
//
//  Created by Max Berghaus on 14.11.22.
//

import SwiftUI
import CoreData
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var image: Image?
    @State private var showingImagePicker = false
    
    
    var body: some View{
        VStack {
            image?
                .resizable()
                .scaledToFit()
            
            Button("select Image"){
                showingImagePicker = true
            }
        }
        .onAppear(perform: loadImage)
        .sheet(isPresented: $showingImagePicker){
            ImagePicker()
        }
    }
    func loadImage(){
//        image = Image("TestImage")        //image doesn't work with with pixel data of an image
        guard let inputImage = UIImage(named: "TestImage") else {return}
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let currentFilter = CIFilter.sepiaTone()
//        let currentFilter = CIFilter.crystallize()
//        let currentFilter = CIFilter.twirlDistortion()
//        let currentFilter = CIFilter.pixellate()
        
        currentFilter.inputImage = beginImage
        
        let amount = 1.0
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey){
            currentFilter.setValue(amount, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey){
            currentFilter.setValue(amount * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey){
            currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent){
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
        }
        
    }
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

