//
//  AppList.swift
//  SneakShare
//
//  Created by EMRE ERTUNC on 14.11.2023.
//

import SwiftUI

struct AppList: View {
    let apps = [
           ("Instagram", "instagram_logo"), // Replace "instagram_logo" with the actual name of the Instagram logo asset
           ("TikTok", "tiktok_logo"),       // Replace "tiktok_logo" with the actual name of the TikTok logo asset
           ("X (twitter)", "twitter_logo")                  // Replace "x_logo" with the actual name of the X app logo asset
       ]

       var body: some View {
           Text("Supported Apps")
               .multilineTextAlignment(.center)
               .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
               .padding()
           List(apps, id: \.0) { app in
               HStack {
                   Image(app.1) // Assumes logo images are in your asset catalog
                       .resizable()
                       .scaledToFit()
                       .frame(width: 50, height: 50)
                   Text(app.0)
               }
           }
       }
}

#Preview {
    AppList()
}
