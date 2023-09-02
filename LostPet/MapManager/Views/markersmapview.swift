//
//  markersmapview.swift
//  LostPet
//
//  Created by Pedro Toledo on 23/8/23.
//

import SwiftUI
import Firebase
struct markersmapview: View {

    let markers : Markers
    
    var body: some View {

        NavigationLink(destination: {
            markersInfoShows(markers: markers)
        }, label: {
            ZStack{
                Circle()
                    .foregroundColor(.green)
                    .frame(width: 30)
                        
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 28)
                        
                // Image(uiImage: image)
                Image(markers.photourl!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26)
                    .shadow(color: .black, radius: 2)
                    .clipShape(Circle())
                        
            }
        })
    }
}

struct markersmapview_Previews: PreviewProvider {
    static var previews: some View {
        markersmapview(markers: Markers(markerID: "prueba", id: 12, date: Date(), photourl: "enana", coordinates: GeoPoint(latitude: 22.22, longitude: 22.22)))
    }
}
