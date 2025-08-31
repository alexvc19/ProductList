//
//  LPProductView.swift
//  ProductList
//
//  Created by Alejandro Velasco on 31/08/25.
//
import Combine
import SwiftUI

struct ProductView: View {
    let product: Product
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: product.imageURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipped()
                        .cornerRadius(10)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(product.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                priceView
                HStack(spacing: 6) {
                    ForEach(product.variantsColor ?? [], id: \.self) { variant in
                        Circle()
                            .fill(Color(hex: variant.colorHex))
                            .frame(width: 20, height: 20)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
        .padding(.horizontal)
    }
    
    private var priceView: some View {
        let formatter: NumberFormatter = {
            let f = NumberFormatter()
            f.numberStyle = .decimal
            f.minimumFractionDigits = 2
            f.maximumFractionDigits = 2
            return f
        }()
        
        return Group {
            if product.listPrice != product.promoPrice {
                HStack(spacing: 8) {
                    Text("$\(formatter.string(from: NSNumber(value: product.listPrice)) ?? "\(product.listPrice)")")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .strikethrough()
                    
                    Text("$\(formatter.string(from: NSNumber(value: product.promoPrice)) ?? "\(product.promoPrice)")")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
            } else {
                Text("$\(formatter.string(from: NSNumber(value: product.listPrice)) ?? "\(product.listPrice)")")
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
        }
    }

}
