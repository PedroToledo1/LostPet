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
            
            AsyncImage(url: markers.photourl)
//                .resizable()
                .scaledToFit()
        }
        Divider()
        HStack{
            Text("Fecha")
            Text("\(markers.date!)")
        }
    }

    }


struct markersInfoShows_Previews: PreviewProvider {
    static var previews: some View {
        markersInfoShows(markers: Markers(markerID: "prueba", id: 12, date: Date(), photourl: URL(string: "hola"), coordinates: GeoPoint(latitude: 22.22, longitude: 22.22), imagepath: "jnbk"))
    }
}
