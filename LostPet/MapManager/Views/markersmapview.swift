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
    @State var url: URL? = nil
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
                
                    AsyncImage(url: url)
                    //                            .resizable()
                        .scaledToFit()
                        .frame(width: 26)
                    //                            .shadow(color: .black, radius: 2)
                        .clipShape(Circle())
                    
                    
                
            }
        })
    }
}

struct markersmapview_Previews: PreviewProvider {
    static var previews: some View {
        markersmapview(markers: Markers(markerID: "prueba", id: 12, date: Date(), photourl: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/lostpet-fd80f.appspot.com/o/markers%2F72F567FD-3099-41AC-A05C-6647B015F002.png?alt=media&token=fac76a92-201e-46fd-8fdb-6031eee066cd"), coordinates: GeoPoint(latitude: 22.22, longitude: 22.22), imagepath: "kdjnsvnjds"))
    }
}
