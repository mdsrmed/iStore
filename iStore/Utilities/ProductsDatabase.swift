//
//  ProductsDatabase.swift
//  iStore
//
//  Created by Md Shohidur Rahman on 8/28/23.
//

import Foundation


struct ProductArray: Codable {
    let products: [Product]
    let total, skip, limit: Int
}

struct Product: Identifiable, Codable {
    let id: Int
    let title: String?
    let description: String?
    let price: Int?
    let discountPercentage: Double?
    let rating: Double?
    let stock: Int?
    let brand,category: String?
    let thumbnail: String?
    let images: [String]?
    
}

//func downloadProductsAndUploadToFirebase(){
//    //https://dummyjson.com/products
//
//    guard let url = URL(string: "https://dummyjson.com/products") else { return }
//
//    Task {
//        do {
//            let (data,response) = try await URLSession.shared.data(from: url)
//            let products = try JSONDecoder().decode(ProductArray.self, from: data)
//            let productArray = products.products
//
//            for product in productArray {
//                try? await ProductsManager.shared.uploadProduct(product: product)
//            }
//        } catch {
//            print(error)
//        }
//    }
//
//}
