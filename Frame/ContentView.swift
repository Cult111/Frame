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
    @State private var filterIntesity = 0.5
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
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
                HStack{
                    Text("Intesity")
                    Slider(value: $filterIntesity)
                        .onChange(of: filterIntesity){ _ in applyProcessing() }
                    
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
                    filter.inputBrightnessFactor = 0.0
                    
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
                    filter.threshold = 1
                    

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

