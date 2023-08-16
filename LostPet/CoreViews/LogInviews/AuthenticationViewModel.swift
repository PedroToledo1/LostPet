//
//  AuthenticationViewModel.swift
//  LostPet
//
//  Created by Pedro Toledo on 16/8/23.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth
import AuthenticationServices
import CryptoKit

@MainActor
final class AuthenticationViewModel: ObservableObject{
    

    @Published var didSignInWithApple: Bool = false
    let signInAppleHelper = SignInAppleHelper()
    
    func signInGoogle() async throws{
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let AuthDataResult = try await AuthenticationManager.shared.signInwithGoogle(tokens: tokens)
        let user = DBUser(auth: AuthDataResult)
        try await UserManager.shared.createNewUser(user: user)
        //try await UserManager.shared.createNewUser(auth: AuthDataResult)
        
    }
    func signInApple() async throws{
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let AuthDataResult = try await AuthenticationManager.shared.signInwithApple(tokens: tokens)
        let user = DBUser(auth: AuthDataResult)
        try await UserManager.shared.createNewUser(user: user)
        //try await UserManager.shared.createNewUser(auth: AuthDataResult)
    }
}

