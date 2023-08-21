//
//  CameraView.swift
//  LostPet
//
//  Created by Pedro Toledo on 18/8/23.
//

import SwiftUI
import PhotosUI


struct CameraView: View {
    
    @StateObject var viewModel = StorageManager()
    
    @State private var photoselected : PhotosPickerItem? = nil
    
    var body: some View {
        PhotosPicker(selection: $photoselected, matching: .images, photoLibrary: .shared(), label:{ Text("Select a photo")})
            .onChange(of: photoselected, perform: { newValue in
                if let newValue {
                    viewModel.saveMarkerImage(item: newValue)
                    print("llego hasta aca")
                }
            })
    }
        
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
