//
//  CameraButtonView.swift
//  Frame
//
//  Created by Max Berghaus on 29.11.22.
//

import SwiftUI

struct CameraButtonView: View {
    @Binding var showActionSheet: Bool
    
    var body: some View {
        Button(action: {
            self.showActionSheet.toggle()
        }) {
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 38, height: 38, alignment: .center)
                .foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .frame(width: 36, height: 36, alignment: .center)
                        .foregroundColor(.white)
                        .overlay(
                            Image(systemName: "camera.fill")
                                .foregroundColor(.black)
                        )
                )
        }
    }
}

struct CameraButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CameraButtonView(showActionSheet: .constant(false))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
