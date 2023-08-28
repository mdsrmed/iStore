//
//  ProductsManager.swift
//  iStore
//
//  Created by Md Shohidur Rahman on 8/28/23.
//

import Foundation
import FirebaseFirestore
import  FirebaseFirestoreSwift



final class ProductsManager{
    
    static let shared = ProductsManager()
    private init(){ }
    
    
    private let productsCollection = Firestore.firestore().collection("products")
    
    private func productDocument(productId: String) -> DocumentReference {
        productsCollection.document(productId)
    }
    
    func uploadProduct(product: Product) async throws {
        try productDocument(productId: String(product.id)).setData(from: product, merge: false)
    }
}
