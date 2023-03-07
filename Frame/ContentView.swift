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
    @State private var brightnessFactor: Float = 0
    @State private var contrastFactor: Float = 0
    @State private var shadowFactor: Float = 0
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    @State private var currentFilter: CIFilter = BrightnessFilter()
    @State private var brightnessFilter: CIFilter = BrightnessFilter()
    @State private var grayscaleFilter: CIFilter = GrayscaleFilter()
    @State private var contrastFilter: CIFilter = ContrastFilter()
    @State private var shadowFilter: CIFilter = ShadowFilter()
    
    let context = CIContext()
    
    @State private var showingFilterSheets = false
    
    var body: some View{
        NavigationView{
            VStack{
                ZStack{
                    Rectangle()
                        .fill(.secondary)
                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    image?
                        .resizable()
                        .scaledToFit()
                    
                    
                    
                }
                .onTapGesture {
                    showingImagePicker = true
                }
                VStack{
                    Text("Brightness")
                    Slider(value: $brightnessFactor, in: -0.3...0.3)
                        .onChange(of: brightnessFactor){ _ in setFilter(BrightnessFilter())}
                        .onChange(of: brightnessFactor){ _ in applyProcessing()}
                    Text("Contrast")
                    Slider(value: $contrastFactor, in: -150...150)
                        .onChange(of: contrastFactor){ _ in setFilter(ContrastFilter())}
                        .onChange(of: contrastFactor){ _ in applyProcessing()}
                    Text("Shadows")
                    Slider(value: $shadowFactor, in: -15...15)
                        .onChange(of: shadowFactor){ _ in setFilter(ContrastFilter())}
                        .onChange(of: shadowFactor){ _ in applyProcessing()}
                }
                .padding(.vertical)
                
                HStack{
                    Spacer()
                    
                    Button("Save", action: save)
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Frame")
            .onChange(of: inputImage){ _ in loadImage() }
            .sheet(isPresented: $showingImagePicker){
                ImagePicker(image: $inputImage)
            }
        }
    }
    
    func loadImage(){
        guard let inputImage = inputImage else { return }
        let beginImage = CIImage(image: inputImage)
//        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

        applyProcessing()
    }
    
    func save(){
        guard let processedImage = processedImage else { return }
        
        let imageSaver = ImageSaver()
        
        imageSaver.successHandler = {
            print("Success!")
        }
        imageSaver.errorHandler = {
            print("Oops! \($0.localizedDescription)")
        }
        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
    
    func applyProcessing(){
        
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains("inputBrightnessFactor"){
            currentFilter.setValue(brightnessFactor, forKey: "inputBrightnessFactor")
        }
        if inputKeys.contains("inputContrastFactor"){
            currentFilter.setValue(contrastFactor, forKey: "inputContrastFactor")
        }
        
// chaning all filter together
        guard let inputImage = inputImage else { return }
        let beginImage = CIImage(image: inputImage)
        contrastFilter.setValue(beginImage, forKey: kCIInputImageKey)
        contrastFilter.setValue(contrastFactor, forKey: "inputContrastFactor")
        
        guard var contrastImage = contrastFilter.outputImage else { return }
        brightnessFilter.setValue(contrastImage, forKey: kCIInputImageKey)
        brightnessFilter.setValue(brightnessFactor, forKey: "inputBrightnessFactor")
 
        guard var outputImage = brightnessFilter.outputImage else { return }
        shadowFilter.setValue(outputImage, forKey: kCIInputImageKey)
        shadowFilter.setValue(shadowFactor, forKey: "inputShadowFactor")
        outputImage = shadowFilter.outputImage!
        
        
        //converting the UIImage to SwiftUi Image, so it can be displayed
        if let cgimg = context.createCGImage( outputImage, from: outputImage.extent){
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage )
            processedImage = uiImage
        }
    }
    
    func setFilter(_ filter: CIFilter){
        currentFilter = filter
        loadImage()
    }
}

    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

