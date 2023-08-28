//
//  ProductsView.swift
//  iStore
//
//  Created by Md Shohidur Rahman on 8/28/23.
//

import SwiftUI


@MainActor
final class ProductsViewModel: ObservableObject {
    
    func downloadProductsAndUploadToFirebase(){
        //https://dummyjson.com/products
        
        guard let url = URL(string: "https://dummyjson.com/products") else { return }
        
        Task {
            do {
                let (data,response) = try await URLSession.shared.data(from: url)
                let products = try JSONDecoder().decode(ProductArray.self, from: data)
                let productArray = products.products
                
                for product in productArray {
                    try? await ProductsManager.shared.uploadProduct(product: product)
                }
            } catch {
                print(error)
            }
        }
        
    }
}

struct ProductsView: View {
    @StateObject var viewModel = ProductsViewModel()
    
    var body: some View {
        ZStack {
            Text("Product")
        }
        .navigationTitle("Products")
        .onAppear {
            viewModel.downloadProductsAndUploadToFirebase()
        }
    }
}
    
    struct ProductsView_Previews: PreviewProvider {
        static var previews: some View {
            ProductsView()
        }
    }

