//
//  CameraView.swift
//  LostPet
//
//  Created by Pedro Toledo on 18/8/23.
//

import SwiftUI
import PhotosUI


struct CameraView: View {
    @State private var photoselected : PhotosPickerItem? = nil
    var body: some View {
        PhotosPicker(selection: $photoselected, matching: .images, photoLibrary: .shared(), label:{ Text("Select a photo")})

    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
