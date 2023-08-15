//
//  AuthenticationManager.swift
//  LostPet
//
//  Created by Pedro Toledo on 15/8/23.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.photoUrl = user.photoURL?.absoluteString
    }
}

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init(){}
    
   /* func getAuthenticatedUser() throws -> AuthDataResultModel{
        guard let user.auth().currentUser else {
            throw URLError(.badURL)
        }
        return AuthDataResultModel(user: user)
    }
    */
    
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
