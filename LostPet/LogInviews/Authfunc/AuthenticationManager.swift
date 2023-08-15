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
    
    func getAuthenticatedUser() throws -> AuthDataResultModel{
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        return AuthDataResultModel(user: user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
// MARK: Sign In SSO
extension AuthenticationManager {
    
    @discardableResult
    func signInwithGoogle(tokens: GoogleSignInResultModel)async throws -> AuthDataResultModel{
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signInwithCredential(credential: credential)
    }
    func signInwithCredential(credential: AuthCredential)async throws -> AuthDataResultModel{
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
}
