//
//  AuthView.swift
//  LostPet
//
//  Created by Pedro Toledo on 15/8/23.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth
import AuthenticationServices
import CryptoKit

struct AuthView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showsignInView: Bool
    
    var body: some View {
        VStack{
            Button(action: {
                Task{
                    do{
                        try await viewModel.signInGoogle()
                        showsignInView = false
                    }catch{
                        print("error google")
                    }
                }
            }, label: {
                HStack{
                    Image(systemName: "globe")
                    Text("Continue with Google")
                }
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color(.sRGB, red: 223/225, green: 82/255, blue: 70/225, opacity: 1.0))
                .cornerRadius(10)
                .font(.system(size: 23, weight: .medium, design: .default))
                .foregroundColor(.white)
            })
            Button(action: {
                Task {
                    do {
                        try await viewModel.signInApple()
                        showsignInView = false
                    } catch {
                        print(error)
                    }
                }
            }, label: {
                SignInWithAppleButtonViewRepresentable(type: .default, style: .black)
                    .allowsHitTesting(false)
            })
            .frame(height: 55)
        }
        .padding()
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(showsignInView: .constant(false))
    }
}
