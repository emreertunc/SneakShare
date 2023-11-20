//
//  BuyMeACoffee.swift
//  SneakShare
//
//  Created by EMRE ERTUNC on 14.11.2023.
//

import SwiftUI

struct BuyMeACoffee: View {
    @Binding var isPresented: Bool
    @Environment(\.openURL) var openURL

    var body: some View {
        VStack {
            Text("buy-me-a-coffee")
                .font(.headline)
                .padding()

            Text(
                "if-you-like")
                .multilineTextAlignment(.center)
                .padding()

            // Bağış linki veya butonu
            Button("buy-me-a-coffee") {
                // Örnek URL
                if let url = URL(string: "https://www.buymeacoffee.com/emreertunc") {
                    openURL(url)
                }
            }
            .padding()

            // Alternatif olarak Link bileşeni kullanılabilir
            Link("donate-page", destination: URL(string: "https://www.buymecoffee.com/")!)
                .padding()

            Button("close") {
                self.isPresented = false
            }
            .foregroundColor(.red)
        }
        //.frame(width: 300, height: 250)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))  // Sistem arka plan rengi
        .foregroundColor(Color(.label))        // Sistem metin rengi
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}

//#Preview {
//    BuyMeACoffee()
//}
