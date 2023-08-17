//
//  RootView.swift
//  iStore
//
//  Created by Md Shohidur Rahman on 8/11/23.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView = false
    
    
    var body: some View {
        ZStack {
            
            if !showSignInView {
                NavigationStack{
                    SettingsView(showSignInView: $showSignInView)           
                }
            }
           
        }
        .onAppear {
            let authenticatedUser = try? AuthenticationManger.shared.getAuthenticatedUser()
            self.showSignInView = authenticatedUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
