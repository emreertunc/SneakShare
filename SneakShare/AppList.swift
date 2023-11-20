//
//  AppList.swift
//  SneakShare
//
//  Created by EMRE ERTUNC on 14.11.2023.
//

import SwiftUI

//old version with logos
/*
struct AppList: View {

   let apps = [
           ("Instagram", "instagram_logo"),
           ("TikTok", "tiktok_logo"),
           ("X (twitter)", "twitter_logo")
       ]

       var body: some View {
           Text("Supported Apps")
               .multilineTextAlignment(.center)
               .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
               .padding()
           List(apps, id: \.0) { app in
               HStack {
                   Image(app.1)
                       .resizable()
                       .scaledToFit()
                       .frame(width: 50, height: 50)
                   Text(app.0)
               }
           }
       }
}
*/

struct AppList: View {
    // Updated version without logos
    var apps: [String] = {
        var tempApps = ["Instagram", "TikTok", "X (twitter)", "Amazon", "Trendyol", "Hepsiburada", "tinyurl.com"]
        
        // Yerelleştirilmiş metni listenin sonuna ekle
        let localizedString = NSLocalizedString("and-any-url", comment: "Represents any URL with trackers")
        tempApps.append(localizedString)
        return tempApps
    }()
    
    var body: some View {
        Text("supported-apps")
            .multilineTextAlignment(.center)
            .font(.title)
            .padding()

        // Using a List for simplicity
        List(apps, id: \.self) { app in
            Text(app)
        }
    }
}

#Preview {
    AppList()
}
