//
//  RootView.swift
//  LostPet
//
//  Created by Pedro Toledo on 15/8/23.
//

import SwiftUI

struct RootView: View {
    @State private var showsignInView: Bool = false
    var body: some View {
        ZStack{
            NavigationStack{
                NavigationBar(showsignInView: $showsignInView)
            }
            .onAppear{
                try? AuthenticationManager.shared.getProvider()
                let authuser = try? AuthenticationManager.shared.getAuthenticatedUser()
                self.showsignInView = authuser == nil ? true : false
            }
        }
        .fullScreenCover(isPresented: $showsignInView){
            NavigationStack{
                AuthView(showsignInView: $showsignInView)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
