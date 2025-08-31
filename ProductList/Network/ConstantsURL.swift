//
//  ConstantsURL.swift
//  ProductList
//
//  Created by Alejandro Velasco on 31/08/25.
//

import Foundation

class ConstantsURL {
    static let baseURL = "https://shoppapp.liverpool.com.mx/appclienteservices/services/v8/plp/sf"
    
    static func buildProductsURL(page: Int = 9, search: String = "", sortOption: String = "predefined") -> URL? {
        var components = URLComponents(string: ConstantsURL.baseURL)
        
        components?.queryItems = [
            URLQueryItem(name: "page-number", value: "\(page)"),
            URLQueryItem(name: "search-string", value: search),
            URLQueryItem(name: "sort-option", value: sortOption),
            URLQueryItem(name: "force-plp", value: "false"),
            URLQueryItem(name: "number-of-items-per-page", value: "40"),
            URLQueryItem(name: "cleanProductName", value: "false")
        ]
        
        return components?.url
    }
}
