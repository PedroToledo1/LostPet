//
//  CameraView.swift
//  LostPet
//
//  Created by Pedro Toledo on 18/8/23.
//

import SwiftUI
import PhotosUI
import Firebase



struct CameraView: View {
    @StateObject private var mark = markersviewModel()
    @StateObject var viewModel = MarkerManager()
    @State var photoselected : PhotosPickerItem? = nil
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                
                    PhotosPicker(selection: $photoselected, matching: .images ,photoLibrary: .shared(),
                                 label:{Image(systemName: "photo.fill")})
                
            }
            Spacer()
            Button(action: {
                if photoselected != nil {
                    viewModel.saveMarkerImage(item: photoselected!)
                    photoselected = nil
                }
            }, label: {
                Text("Upload Photo")
            })
            .buttonStyle(.bordered)
            Spacer()
        }
        
    }
        
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
