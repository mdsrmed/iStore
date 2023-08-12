//
//  AuthenticationManager.swift
//  iStore
//
//  Created by Md Shohidur Rahman on 8/11/23.
//

import Foundation
import FirebaseAuth


struct AuthDataResultModel {
    
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User){
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}


final class AuthenticationManger {
    
    static let shared = AuthenticationManger()
     
    private init(){ }
    
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
       let authResult =  try await Auth.auth().createUser(withEmail: email, password: password)
       return AuthDataResultModel(user: authResult.user)
    }
    
    
    @discardableResult
    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
       let authResult =  try await Auth.auth().signIn(withEmail: email, password: password)
       return AuthDataResultModel(user: authResult.user)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updateEmail(email: String) async throws {
       guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
       try await user.updateEmail(to: email)
    }
    
    func updatePassword(password: String) async throws {
       guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
       try await user.updatePassword(to: password)
    }
    
    
    
    func signOut() throws {
       try  Auth.auth().signOut()
    }
    
    
    
}
