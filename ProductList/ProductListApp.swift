//
//  ProductListApp.swift
//  ProductList
//
//  Created by Alejandro Velasco on 31/08/25.
//

import SwiftUI

@main
struct ProductListApp: App {
    init(){
        let appearance = UINavigationBarAppearance()
        if let mainColor = UIColor(named: "MainColor") {
            appearance.backgroundColor = mainColor
        }
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            ProductListView()
                 .preferredColorScheme(.light)
        }
    }
}
