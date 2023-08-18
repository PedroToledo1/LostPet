//
//  MarkerManager.swift
//  LostPet
//
//  Created by Pedro Toledo on 17/8/23.
//

import Foundation

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation

struct DBMarker {
    let marker_id: String
    let photo_url: UIImage
    let coordinate: CLLocationCoordinate2D
    let date_created : Date
    let userId: String
}

final class markerManager {
    
    static let shared = markerManager()
    private init(){}
    
    private let  markerCollection = Firestore.firestore().collection("markers")
    
    private func markerDocument(marker_id: String)->DocumentReference{
        markerCollection.document(marker_id)
    }
    
}
