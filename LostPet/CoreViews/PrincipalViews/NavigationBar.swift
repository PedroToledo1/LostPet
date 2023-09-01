//
//  NavigationBar.swift
//  LostPet
//
//  Created by Pedro Toledo on 18/8/23.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct NavigationBar: View {
    @StateObject private var mark = markersviewModel()
    @Binding var showsignInView: Bool
    var body: some View {
        NavigationStack {
            
            TabView{
                NavigationView {
                    MapView()
                }
                .tabItem{
                    Image(systemName: "map.circle")
                    Text("Map")
                }
                NavigationView {
                    CameraView()
                }
                .tabItem{
                    Image(systemName: "camera.circle")
                    Text("Camara")
                }
                NavigationView {
                    ProfileViews(showsignInView: $showsignInView)
                }
                .tabItem{
                    Image(systemName: "person.crop.circle")
                    Text("Account")
                }
            }
            .onAppear{
                Task {
                    try? await mark.getAllMarkers()
                    print("succes import markers")
                    print([mark.markers])
                }
            }
        }
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(showsignInView: .constant(false))
    }
}
