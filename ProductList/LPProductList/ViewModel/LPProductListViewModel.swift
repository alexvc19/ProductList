//
//  Untitled.swift
//  ProductList
//
//  Created by Alejandro Velasco on 31/08/25.
//

import Combine
import SwiftUI

class LPProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var currentPage: Int = 1
    @Published var canLoadMore: Bool = true
    @Published var sortOptions: [SortOption] = []

    private var currentQuery: String = ""
    private var currentSort: SortOption?
    private var cancellables = Set<AnyCancellable>()

    func fetchProducts() {
        currentPage = 1
        canLoadMore = true
        currentQuery = ""
        
        let defaultSort = sortOptions.first?.sortBy ?? "predefined"
        loadProducts(page: currentPage, query: currentQuery, sort: defaultSort, isAppending: false)
    }

    func searchProducts(query: String, sort: SortOption?) {
        currentQuery = query
        currentSort = sort
        
        currentPage = 1
        canLoadMore = true
        
        let sortParam = currentSort?.sortBy ?? "predefined"
        loadProducts(page: currentPage, query: currentQuery, sort: sortParam, isAppending: false)
    }

    func loadNextPage() {
        guard !isLoading, canLoadMore else { return }
        currentPage += 1
        loadProducts(page: currentPage, query: currentQuery, sort: currentSort?.sortBy ?? "", isAppending: true)
    }

    private func loadProducts(page: Int, query: String, sort: String, isAppending: Bool) {
        isLoading = true
        errorMessage = nil

        guard let url = ConstantsURL.buildProductsURL(page: page, search: query, sortOption: sort) else {
            print("URL inválida")
            return
        }

        NetworkManager.shared
            .request(url.absoluteString, responseType: PLPResponse.self)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print(error)
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                if isAppending {
                    self.products.append(contentsOf: response.plpResults.records)
                } else {
                    self.products = response.plpResults.records
                }
                self.canLoadMore = !response.plpResults.records.isEmpty

                self.sortOptions = response.plpResults.sortOptions
            }
            .store(in: &cancellables)
    }
}
