//
//  ProductsView.swift
//  iStore
//
//  Created by Md Shohidur Rahman on 8/28/23.
//

import SwiftUI


@MainActor
final class ProductsViewModel: ObservableObject {
    
    @Published private(set) var products: [Product] = []
    
    func getAllProducts() async throws {
        self.products = try await ProductsManager.shared.getAllProducts()
    }
}

struct ProductsView: View {
    @StateObject var viewModel = ProductsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.products){ product in
                ProductCellView(product: product)
            }
        }
        .navigationTitle("Products")
        .task {
            try? await viewModel.getAllProducts()
        }
    }
}
    
    struct ProductsView_Previews: PreviewProvider {
        static var previews: some View {
            ProductsView()
        }
    }

