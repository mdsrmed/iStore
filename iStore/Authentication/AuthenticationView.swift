//
//  AuthenticationView.swift
//  iStore
//
//  Created by Md Shohidur Rahman on 8/11/23.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift




@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    func signInGoogle () async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        try await AuthenticationManger.shared.signInWithGoogle(tokens: tokens)
    }
    
}


struct AuthenticationView: View {
    
    @Binding var showSignInView: Bool
    @StateObject var viewModel =  AuthenticationViewModel()
    
    var body: some View {
        VStack {
            
            NavigationLink {
                SigninEmailView(showSignInView: $showSignInView)
            } label: {
                Text("Sign In With Email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.blue)
                    .cornerRadius(10)
            }
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark,style: .wide, state: .normal)) {
                Task{
                    do {
                        try await viewModel.signInGoogle()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In")
    }
    
    struct AuthenticationView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationStack {
                AuthenticationView(showSignInView: .constant(false))
            }
        }
    }
}
