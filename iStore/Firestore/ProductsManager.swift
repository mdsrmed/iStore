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
    
    func getProduct(productId: String) async throws -> Product {
        try await productDocument(productId: productId).getDocument(as: Product.self)
    }
    
    func getAllProducts() async throws -> [Product]  {
        try await productsCollection.getAllProducts(as: Product.self)
    }
}

extension Query {
    func getAllProducts<T: Decodable>(as type: T.Type) async throws -> [T]  {
      let snapshot =  try await self.getDocuments()
        
//        let products = try snapshot.documents.map({document in
//            let product = try document.data(as: T.self)
//            return product
//        })
        
        var products: [T] = []
        for document in snapshot.documents{
            let product = try document.data(as: T.self)
            products.append(product)
        }
        
        return products
    }
}


