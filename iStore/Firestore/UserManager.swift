//
//  UserManager.swift
//  iStore
//
//  Created by Md Shohidur Rahman on 8/22/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct DBUser {
    let userId: String
    let isAnonymous: Bool?
    let dateCreated: Date?
    let email: String?
    let photoUrl: String?
}

final class UserManager{

    static let shared = UserManager()
    private init(){ }
    
    func createNewUser(auth: AuthDataResultModel) async throws {
        
        var userData: [String: Any] = [
            "user_id": auth.uid,
            "is_anonymous": auth.isAnonymous,
            "date_created": Timestamp(),
        ]
        
        if let email = auth.email {
            userData["email"] = email
        }
        if let photoUrl = auth.photoUrl{
            userData["photo_url"] = photoUrl
        }
        
       try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        
        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        
        let isAnonymous = data["is_anonymous"] as? Bool
        let dateCreated = data["date_created"] as? Date
        let email = data["email"] as? String
        let photoUrl = data["photo_url"] as? String
        
        return DBUser(userId: userId, isAnonymous: isAnonymous, dateCreated: dateCreated, email: email, photoUrl: photoUrl)
    }
    
}
