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
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
       let authResult =  try await Auth.auth().createUser(withEmail: email, password: password)
       return AuthDataResultModel(user: authResult.user)
    }
    
    
    func signOut() throws {
       try  Auth.auth().signOut()
    }
    
}
