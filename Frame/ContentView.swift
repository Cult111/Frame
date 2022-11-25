//
//  ContentView.swift
//  Frame
//
//  Created by Max Berghaus on 14.11.22.
//

import SwiftUI
import CoreData

struct ContentView: View {
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
            
            Image ("TestImage")
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
