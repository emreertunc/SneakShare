//
//  About.swift
//  SneakShare
//
//  Created by EMRE ERTUNC on 14.11.2023.
//

import SwiftUI

struct About: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("about-sneakshare")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("hey-there")
                
                Text("whats-sneakshare")
                    .font(.headline)
                
                Text("whats-sneakshare-answer")
                
                Text("why-sneakshare")
                    .font(.headline)
                
                Text("why-sneakshare-answer")
                
                Image("anonymizedURLExample")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width - 40)

                Text("what-we-offer")
                    .font(.headline)
                
                Text("what-we-offer-answer")


                Text("labor-of-love")

                Text("get-in-touch")
                    .font(.headline)
                
                Text("get-in-touch-answer")

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    About()
}
