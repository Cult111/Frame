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
    @State private var grayscaleFactor: Float = 0
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    @State private var currentFilter: CIFilter = BrightnessFilter()

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
                    Slider(value: $brightnessFactor, in: -1...1)
                        .onChange(of: brightnessFactor){ _ in setFilter(BrightnessFilter())}
                        .onChange(of: brightnessFactor){ _ in applyProcessing()}
                    Text("Grayscale")
                    Slider(value: $grayscaleFactor, in: 0...1)
                        .onChange(of: grayscaleFactor){ _ in setFilter(GrayscaleFilter())}
                        .onChange(of: grayscaleFactor){ _ in applyProcessing()}
                }
                .padding(.vertical)
                
                HStack{
                    Button("Change Filter"){
                        showingFilterSheets = true
                    }
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
            .confirmationDialog("Select a filter", isPresented: $showingFilterSheets){
                // Grayscale is a filter without a value that can be set
                Button("Grayscale"){
                    guard let inputImage = inputImage else { return }
                    let beginImage = CIImage(image: inputImage)
                    
                    
                    let filter = GrayscaleFilter()
                    filter.inputImage = beginImage
                    
                    guard let outputImage = filter.outputImage else { return }
                    if let cgimg = context.createCGImage( outputImage, from: outputImage.extent){
                        let uiImage = UIImage(cgImage: cgimg)
                        image = Image(uiImage: uiImage )
                        processedImage = uiImage
                    }}
                Button("BrightnessFilter"){
                    guard let inputImage = inputImage else { return }
                    let beginImage = CIImage(image: inputImage)
                    
                    let filter = BrightnessFilter()
                    filter.inputImage = beginImage
                    filter.inputBrightnessFactor = brightnessFactor
                    
                    guard let outputImage = filter.outputImage else { return }
                    if let cgimg = context.createCGImage( outputImage, from: outputImage.extent){
                        let uiImage = UIImage(cgImage: cgimg)
                        image = Image(uiImage: uiImage )
                        processedImage = uiImage
                    }}
                Button("ThresholdFilter"){
                    guard let inputImage = inputImage else { return }
                    let beginImage = CIImage(image: inputImage)
                    
                    let filter = ThresholdFilter()
                    filter.inputImage = beginImage
                    filter.inputThresholdFactor = 1
                    

                    guard let outputImage = filter.outputImage else { return }
                    if let cgimg = context.createCGImage( outputImage, from: outputImage.extent){
                        let uiImage = UIImage(cgImage: cgimg)
                        image = Image(uiImage: uiImage )
                        processedImage = uiImage
                    }
                }
                Button("Cancel", role: .cancel) { }
                
            }
        }
    }
    
    func loadImage(){
        guard let inputImage = inputImage else { return }
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

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
        if inputKeys.contains("inputGrayscaleFactor"){
            currentFilter.setValue(grayscaleFactor, forKey: "inputGrayscaleFactor")
        }
            
        guard let outputImage = currentFilter.outputImage else { return }
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

