//
//  UserManager.swift
//  LostPet
//
//  Created by Pedro Toledo on 16/8/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserManager {
    static let shared = UserManager()
    private init(){}
    
    
    func createNewUser(auth: AuthDataResultModel) async throws{
        var userData: [String: Any] = [
            "user_id": auth.uid,
            "date_created": Timestamp()
        ]
        if let email = auth.email{
            userData["email"] = email
        }
        if let photourl = auth.photoUrl{
            userData["photo_url"] = photourl
        }
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
    }
}
