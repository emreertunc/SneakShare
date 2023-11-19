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
                Text("About SneakShare")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Hey there, welcome to SneakShare! I'm Emre, the developer behind this little yet mighty app. SneakShare is here to help you anonymize and share your URLs in a snap.")
                
                Text("What's SneakShare?")
                    .font(.headline)
                
                Text("In a nutshell, SneakShare is an app that helps you share your URLs sneakily. Whether it's a link to a news article, a video, or an online product, SneakShare's got your back in keeping you and your privacy secure.")
                
                Text("Why SneakShare?")
                    .font(.headline)
                
                Text("Simple. Because privacy matters. SneakShare elevates your internet experience by ensuring that you and your shares are safe and sound.")
                
                Image("anonymizedURLExample")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width - 40)

                Text("What We Offer")
                    .font(.headline)
                
                Text("Privacy: We strip your URLs of any tracking parameters.\nEasy Sharing: We shorten your URLs for hassle-free sharing. (to be added)\nUser-Friendly: A simple and effective interface that's easy for everyone to use.")


                Text("SneakShare is a labor of love from a curious developer. Although I'm working solo, I'm committed to keeping the app up-to-date and making it better. Your ideas and feedback are gold to me, so I'm all ears!")

                Text("Get in Touch")
                    .font(.headline)
                
                Text("Have questions or suggestions? Drop me a line at emre@ertunc.com")

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    About()
}
