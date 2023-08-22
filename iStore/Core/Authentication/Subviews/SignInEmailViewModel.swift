//
//  SignInEmailViewModel.swift
//  iStore
//
//  Created by Md Shohidur Rahman on 8/21/23.
//

import Foundation


@MainActor
final class SignInEmailViewModel: ObservableObject {
    
    
    @Published var email:String = ""
    @Published var password: String = ""
    
    
    func signUp() async throws {
        guard  !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        try await UserManager.shared.createNewUser(auth: authDataResult)
    }
    
    
    func signIn() async throws {
        guard  !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
      try await AuthenticationManager.shared.signIn(email: email, password: password)
    }

}
