//
//  UserManager.swift
//  LostPet
//
//  Created by Pedro Toledo on 16/8/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser{
    let userID : String
    let email : String?
    let photourl : String?
    let dateCreated : Date?
}

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
    
    func getUser(UserID: String) async throws -> DBUser {
        let snapshot = try await Firestore.firestore().collection("users").document(UserID).getDocument()
        guard let data = snapshot.data() else {
            throw URLError(.badURL)
        }
        let userID = data["user_id"] as? String
        let email = data["email"] as? String
        let photourl = data["photo_url"] as? String
        let dateCreated = data["date_created"] as? Date
        
        return DBUser(userID: UserID, email: email, photourl: photourl, dateCreated: dateCreated)
        
    }
}
