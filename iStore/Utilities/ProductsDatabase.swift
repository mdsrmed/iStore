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
