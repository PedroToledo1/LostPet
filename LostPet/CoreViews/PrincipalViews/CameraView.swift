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
    @StateObject var viewModel = StorageManager()
    @State var photoselected : PhotosPickerItem! = nil
    
    var body: some View {
        VStack{
            Spacer()
            ZStack{
                if photoselected != nil {
                    
                }
            }
            PhotosPicker(selection: $photoselected, matching: .images ,photoLibrary: .shared(),
                         label:{Text("Open library")})
            
            Spacer()
            Button(action: {
                if photoselected == nil {
                    
                }else{
                    viewModel.saveMarkerImage(item: photoselected)
                    photoselected = nil
                }
            }, label: {
                Text("Upload Photo")
            })
            Spacer()
        }
    }
        
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
