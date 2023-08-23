//
//  markersmapview.swift
//  LostPet
//
//  Created by Pedro Toledo on 23/8/23.
//

import SwiftUI

struct markersmapview: View {
    var body: some View {

        NavigationLink(destination: {
        
        }, label: {
            ZStack{
                Circle()
                    .foregroundColor(.green)
                    .frame(width: 22)
                        
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 20)
                        
                // Image(uiImage: image)
                Image(systemName: "gear")
                    .frame(width: 18)
                    .shadow(color: .black, radius: 2)
                    .clipShape(Circle())
                        
            }
        })
    }
}

struct markersmapview_Previews: PreviewProvider {
    static var previews: some View {
        markersmapview()
    }
}
