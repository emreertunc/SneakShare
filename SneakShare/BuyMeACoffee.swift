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
            Text("Buy Me a Coffee")
                .font(.headline)
                .padding()

            Text(
                "If you like my app, you can support me through the links below to continue keeping my app on the App Store.")
                .multilineTextAlignment(.center)
                .padding()

            // Bağış linki veya butonu
            Button("Buy me a coffee") {
                // Örnek URL
                if let url = URL(string: "https://www.buymeacoffee.com/emreertunc") {
                    openURL(url)
                }
            }
            .padding()

            // Alternatif olarak Link bileşeni kullanılabilir
            Link("Donate page", destination: URL(string: "https://www.buymecoffee.com/")!)
                .padding()

            Button("Close") {
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
