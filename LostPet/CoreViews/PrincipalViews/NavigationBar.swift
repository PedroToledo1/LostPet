//
//  NavigationBar.swift
//  LostPet
//
//  Created by Pedro Toledo on 18/8/23.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct NavigationBar: View {

    @Binding var showsignInView: Bool
    var body: some View {
        
            
            TabView{
                NavigationView {
                    MapView()
                }
                .tabItem{
                    Image(systemName: "map.circle")
                    Text("Map")
                }
                .toolbarBackground(Color.white, for: .tabBar)
                NavigationView {
                    CameraView()
                }
                .tabItem{
                    Image(systemName: "camera.circle")
                    Text("Camara")
                }
                .toolbarBackground(Color.white, for: .tabBar)
                NavigationView {
                    ProfileViews(showsignInView: $showsignInView)
                }
                
                .tabItem{
                    Image(systemName: "person.crop.circle")
                    Text("Account")
                }
                
        }
            .toolbarBackground(Color.white, for: .tabBar)
            
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(showsignInView: .constant(false))
    }
}
