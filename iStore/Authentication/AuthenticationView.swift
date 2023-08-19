//
//  AuthenticationView.swift
//  iStore
//
//  Created by Md Shohidur Rahman on 8/11/23.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices
import CryptoKit


@MainActor
final class AuthenticationViewModel: ObservableObject {
    
   // let signInAppleHelper = SignInAppleHelper()
    
    
    func signInGoogle () async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
    }
    
    //Apple
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        try await AuthenticationManager.shared.signInWithApple(tokens: tokens)

    }
    
    func signInAnonymous() async throws {
        try await AuthenticationManager.shared.signInAnonymous()

    }
}

struct AuthenticationView: View {
    
    @Binding var showSignInView: Bool
    @StateObject var viewModel =  AuthenticationViewModel()
    
    var body: some View {
        VStack {
            
            Button {
                Task{
                    do {
                        try await viewModel.signInAnonymous()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Sign In Anonymously")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.green)
                    .cornerRadius(10)
            }
            
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
            
            //Apple
            Button {
                Task{
                    do {
                        try await viewModel.signInApple()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            } label: {
                SignInWithAppleButtonViewRepresentable(type: .default, style: .black)
                    .allowsHitTesting(false)
            }
            .frame(height: 55)
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
