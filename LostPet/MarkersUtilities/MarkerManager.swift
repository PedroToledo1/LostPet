//
//  MarkerManager.swift
//  LostPet
//
//  Created by Pedro Toledo on 17/8/23.
//
import SwiftUI
import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseStorageCombineSwift
import FirebaseFirestoreSwift
import PhotosUI

struct MarkerManagerData {
    let date: Date
    let photomarker: String
    
    init(marker: MarkerManagerData) {
        self.photomarker = marker.photomarker
        self.date = marker.date
    }
}

final class StorageManager: ObservableObject {
    
    static let shared = StorageManager()
    init(){}
    private let storage = Storage.storage().reference()
    
    func createNewMarkerManager(){
    }
    
    func saveImage(data: Data) async throws -> (path: String, name: String){
        let meta = StorageMetadata()
        meta.contentType = "image/png"
        print("save image paso 1")
        let path = "\(UUID().uuidString).png"
        print(path)
        let returnMetaData = try await storage.child(path).putDataAsync(data, metadata: meta)
        print("save image parte 2")
        
        guard let ReturnPath = returnMetaData.path, let ReturnName = returnMetaData.name else {
            throw URLError(.cancelled)
            
        }
        print(ReturnPath)
        print(ReturnName)
        return(ReturnPath, ReturnName)
    }
    
    func saveMarkerImage(item: PhotosPickerItem) {
        Task {
            guard let data = try await item.loadTransferable(type: Data.self) else { return }
            print("savemarker image parte 1")
            let (path, name) = try await StorageManager.shared.saveImage(data: data)
            print("success")
            print(path)
            print(name)
        }
    }
}
