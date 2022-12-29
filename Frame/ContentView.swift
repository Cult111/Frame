//
//  ContentView.swift
//  Frame
//
//  Created by Max Berghaus on 14.11.22.
//

import SwiftUI
import CoreData

struct ContentView: View {

    @State var showImagePicker: Bool = false
    @State var showActionSheet: Bool = false
    @State var image: Image?
    @State var sourceType: Int = 0
    
    @State private var blurIntensity: CGFloat = 0
    @State private var hueAdjust: Double = 0
    @State private var contrastAdjust: Double = 1
    @State private var opacityAdjust: Double = 1
    @State private var brightnessAdjust: Double = 0
    @State private var saturationAdjust: Double = 1
    
    var body: some View {
        VStack {
            Text ("Frame" )
                .font (. largeTitle)
            
            Spacer()
            Spacer()
            Spacer()
            
            //Image ("TestImage")
            image?
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(opacityAdjust)
                .hueRotation(Angle (degrees: hueAdjust))
                .brightness(brightnessAdjust)
                .contrast(contrastAdjust)
            //.colorInvert ()
                .saturation(saturationAdjust)
                .blur(radius: blurIntensity)
            
            Spacer ()
            ZStack {
                VStack {
                    // Adjust blur intensity
                    HStack(spacing: 20) {
                        Text ("Blur:")
                            .foregroundColor (Color (.systemBlue) )
                        Slider (value: $blurIntensity, in: 0...10)
                    }.padding(.horizontal, 50)
                    
                    // Adjust brightness
                    HStack(spacing: 20) {
                        Text("Brightness:")
                            .foregroundColor (Color (.systemBlue) )
                        Slider (value: $brightnessAdjust, in: 0...1)
                    }.padding (.horizontal, 50)
                    
                    // Adjust contrast
                    HStack(spacing: 20) {
                        Text ("Contrast:")
                            .foregroundColor (Color (.systemBlue))
                        Slider (value: $contrastAdjust, in: 0...2)
                    }.padding (.horizontal, 50)
                    
                    // Adjust saturation
                    HStack(spacing: 20) {
                        Text ("Saturation:")
                            .foregroundColor(Color (.systemBlue) )
                        Slider (value: $saturationAdjust, in: 0...1)
                    }.padding (.horizontal, 50)
                    
                    // Adjust huerotation
                    HStack(spacing: 20) {
                        Text ("Rotate Chroma:")
                            .foregroundColor(Color (.systemBlue) )
                        Slider (value: $hueAdjust, in: 0...90)
                    }.padding (.horizontal, 50)
                    
                    // Adjust opacity
                    HStack(spacing: 20) {
                        Text ("Transparency:")
                            .foregroundColor (Color (.systemBlue))
                        Slider (value: $opacityAdjust, in: 0...1)
                    }.padding (.horizontal, 50)
                    
                    // Show the Button to change the Image
                    CameraButtonView(showActionSheet: $showActionSheet)
                    // Button to Save the edited
/*                    Button {
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        
                    } label: {
                        HStack {
                            Image(systemName: "photo.on.rectangle.angled")
                            Text("Add to Photos")
                            
                        }
                        .font(.title)
                        .foregroundColor(.purple)
                        
                    }
  */
                    
                }
                // Shows the selection of Camera and Photo Gallery poping up from the bottom
                .actionSheet(isPresented: $showActionSheet, content: { () -> ActionSheet in ActionSheet(title: Text("Select Image"), message : Text("Please selcet an image from the image gallery or use the camera"), buttons: [
                    ActionSheet.Button.default(Text("Camera"), action: {
                        self.sourceType = 0
                        self.showImagePicker.toggle()
                    }),
                    ActionSheet.Button.default(Text("Photo Gallery"), action: {
                        self.sourceType = 1
                        self.showImagePicker.toggle()
                    }),
                    ActionSheet.Button.cancel()
                ])
                })
                if showImagePicker {
                    ImagePicker(isVisible: $showImagePicker, image: $image, sourceType: sourceType)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

