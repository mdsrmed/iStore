//
//  AuthenticationViewModel.swift
//  iStore
//
//  Created by Md Shohidur Rahman on 8/21/23.
//

import Foundation


@MainActor
final class AuthenticationViewModel: ObservableObject {
    
   // let signInAppleHelper = SignInAppleHelper()
    
    
    func signInGoogle () async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        let user = DBUser(userId: authDataResult.uid, isAnonymous: authDataResult.isAnonymous, dateCreated: Date(), email: authDataResult.email, photoUrl: authDataResult.photoUrl)
        try await UserManager.shared.createNewUser(user: user)
    }
    
    //Apple
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
        let user = DBUser(userId: authDataResult.uid, isAnonymous: authDataResult.isAnonymous, dateCreated: Date(), email: authDataResult.email, photoUrl: authDataResult.photoUrl)
        try await UserManager.shared.createNewUser(user: user)

    }
    
    func signInAnonymous() async throws {
       let authDataResult =  try await AuthenticationManager.shared.signInAnonymous()
        let user = DBUser(userId: authDataResult.uid, isAnonymous: authDataResult.isAnonymous, dateCreated: Date(), email: authDataResult.email, photoUrl: authDataResult.photoUrl)
        try await UserManager.shared.createNewUser(user: user)
       //try await UserManager.shared.createNewUser(auth: authDataResult)
    }
}
