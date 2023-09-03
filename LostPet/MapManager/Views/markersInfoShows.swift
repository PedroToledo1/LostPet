//
//  markersInfoShows.swift
//  LostPet
//
//  Created by Pedro Toledo on 2/9/23.
//

import SwiftUI
import Firebase

struct markersInfoShows: View {
    let markers : Markers
    @State var image: UIImage? = nil
    var body: some View {
        
        VStack{
            if let image{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
            Divider()
            HStack{
                Text("Fecha")
                Text("\(markers.date!)")
            }
        }
        .task {
            do{
                if markers.imagepath != nil{
                    let image = try? await MarkerManager.shared.getUIImage(markerID: markers.markerID, path: markers.imagepath!)
                    self.image = image
                }
            }
        }
    }
}

struct markersInfoShows_Previews: PreviewProvider {
    static var previews: some View {
        markersInfoShows(markers: Markers(markerID: "prueba", id: 12, date: Timestamp(), photourl: "enana", coordinates: GeoPoint(latitude: 22.22, longitude: 22.22), imagepath: "jnbk"))
    }
}
