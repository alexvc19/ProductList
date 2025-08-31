//
//  ContentView.swift
//  ProductList
//
//  Created by Alejandro Velasco on 31/08/25.
//

import Combine
import SwiftUI

struct ProductListView: View {
    @StateObject private var viewModel = LPProductViewModel()
    @State private var searchText: String = ""
    @State private var selectedSort: SortOption? = nil

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    if viewModel.products.isEmpty && !viewModel.isLoading {
                        Text("No se encontraron productos")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(viewModel.products) { product in
                            ProductView(product: product)
                                .frame(maxWidth: .infinity)
                                .onAppear {
                                    if product.id == viewModel.products.last?.id {
                                        viewModel.loadNextPage()
                                    }
                                }
                        }

                        if viewModel.isLoading && viewModel.currentPage > 1 {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .background(Color(.systemBackground))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !viewModel.sortOptions.isEmpty {
                        Menu {
                            ForEach(viewModel.sortOptions) { option in
                                Button(option.label) {
                                    viewModel.searchProducts(query: searchText, sort: option)
                                }
                            }
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Buscar")
            .onChange(of: searchText) { query in
                if let sort = selectedSort ?? viewModel.sortOptions.first {
                    viewModel.searchProducts(query: query, sort: sort)
                }
            }            .onAppear {
                viewModel.fetchProducts()
            }
        }
    }

    @ViewBuilder
    private func sortMenu(options: [SortOption]) -> some View {
        Menu {
            ForEach(options) { option in
                Button(option.label) {
                    selectedSort = option
                    viewModel.searchProducts(query: searchText, sort: option)
                }
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
                .foregroundColor(.white)
        }
    }
}

