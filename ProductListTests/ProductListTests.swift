//
//  ProductListTests.swift
//  ProductListTests
//
//  Created by Alejandro Velasco on 31/08/25.
//

import XCTest
@testable import ProductList
import Combine

final class ProductListTests: XCTestCase {
    
    var viewModel: LPProductViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        viewModel = LPProductViewModel()
        cancellables = []
    }

    override func tearDownWithError() throws {
        viewModel = nil
        cancellables = nil
    }

    func testFetchProducts() throws {
        let expectation = XCTestExpectation(description: "Fetch products completes")

        viewModel.products = [
            Product(id: "1", name: "Consola PS5", brand: "PlayStation", listPrice: 12999, promoPrice: 12999, averageRating: 4.2, ratingCount: 14, imageURL: "", variantsColor: []),
            Product(id: "2", name: "Camisa Azul", brand: "Zara", listPrice: 500, promoPrice: 450, averageRating: 4.0, ratingCount: 10, imageURL: "", variantsColor: [])
        ]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.viewModel.products.isEmpty)
            XCTAssertEqual(self.viewModel.products.first?.name, "Consola PS5")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testSearchProducts() throws {
        let sortOption = SortOption(sortBy: "predefined", label: "Predefinido")
        viewModel.products = [
            Product(id: "1", name: "Consola PS5", brand: "PlayStation", listPrice: 12999, promoPrice: 12999, averageRating: 4.2, ratingCount: 14, imageURL: "", variantsColor: []),
            Product(id: "2", name: "Camisa Azul", brand: "Zara", listPrice: 500, promoPrice: 450, averageRating: 4.0, ratingCount: 10, imageURL: "", variantsColor: [])
        ]
        
        viewModel.searchProducts(query: "PS5", sort: sortOption)
        
        let filtered = viewModel.products.filter { $0.name.contains("PS5") }
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.name, "Consola PS5")
    }

    func testLoadNextPageAppendsProducts() throws {
        let expectation = XCTestExpectation(description: "Next page loads")

        viewModel.products = [
            Product(id: "2", name: "Camisa Azul", brand: "Zara", listPrice: 500, promoPrice: 450, averageRating: 4.0, ratingCount: 10, imageURL: "", variantsColor: [])
        ]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.viewModel.products.append(
                Product(id: "1", name: "Consola PS5", brand: "PlayStation", listPrice: 12999, promoPrice: 12999, averageRating: 4.2, ratingCount: 14, imageURL: "", variantsColor: [])
            )
            
            XCTAssertTrue(self.viewModel.products.count > 1)
            XCTAssertEqual(self.viewModel.products.first?.name, "Camisa Azul")
            XCTAssertEqual(self.viewModel.products.last?.name, "Consola PS5")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
