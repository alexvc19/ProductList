//
//  LPProductListModel.swift
//  ProductList
//
//  Created by Alejandro Velasco on 31/08/25.
//

import Foundation

struct PLPResponse: Decodable {
    let plpResults: PLPResults
}

struct PLPResults: Decodable {
    let sortOptions: [SortOption]
    let records: [Product]
}

struct Product: Identifiable, Decodable {
    let id: String
    let name: String
    let brand: String
    let listPrice: Double
    let promoPrice: Double
    let averageRating: Double
    let ratingCount: Int
    let imageURL: String
    let variantsColor: [ColorVariant]

    enum CodingKeys: String, CodingKey {
        case id = "productId"
        case name = "productDisplayName"
        case brand
        case listPrice
        case promoPrice
        case averageRating = "productAvgRating"
        case ratingCount = "productRatingCount"
        case imageURL = "smImage"
        case variantsColor
    }
}

struct ColorVariant: Decodable, Hashable {
    let colorName: String
    let colorHex: String
    let colorMainURL: String
    let galleryImages: [String]?
}

struct SortOption: Identifiable, Codable {
    let sortBy: String
    let label: String

    var id: String { sortBy }
}
