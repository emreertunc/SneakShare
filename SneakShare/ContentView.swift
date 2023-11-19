//
//  ContentView.swift
//  SneakShare
//
//  Created by EMRE ERTUNC on 8.11.2023.
//

import SwiftUI
import UIKit

//genel url temizliği için 3rd party kütüphane
import Foundation


// ActivityView, UIActivityViewController'ı temsil eder.
struct ActivityView: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// API çağrısı için Global değişken tanımlama
var globalSpecialHosts: [String] = []

struct ContentView: View {
    @State private var inputURL: String = ""
    @State private var processedURL: String = ""
    @State private var cleanedURL: String = ""
    @State private var showingNotification: Bool = false
    @State private var showingShareSheet: Bool = false
    @State private var isLoading: Bool = false  // Yükleniyor durumunu takip etmek için yeni durum değişkeni
    @State private var errorMessage: String = "" //hata mesajı vermek için değişken
    @State private var showBuyMeACoffeePopup = false
    @State private var specialHosts: [String] = [] // specialhostnameleri jsondan çekmek için
    
    var body: some View {
        //navigationview üstteki butonlar için eklendi
        NavigationView {
            VStack {
                
                Spacer()
                
                Text("To share the content sneakily:")
                    .font(.title2)
                    .padding()
                
                HStack {
                    TextField("Enter your URL here", text: $inputURL)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                
                // Eğer yükleme durumundaysa bir ProgressView göster
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
                
                Button(action: {
                    // Klavyeyi kapat
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    // URL işlemeye devam et
                    processAndCopyURL()
                })
                {
                    Text("Anonymize URL")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                // Kısaltılmış URL'i ve paylaş butonunu sadece varsa göster
                if !cleanedURL.isEmpty {
                    VStack(alignment: .center) {
                        Text("Anonymized URL:")
                        Text(cleanedURL)
                            .padding(.bottom)
                    }
                    .padding()
                    
                    HStack{
                        // Paylaş butonu
                        Button(action: shareButtonPressed) {
                            Text("Share")
                            Image(systemName: "square.and.arrow.up")
                                .padding()
                        }
                        .disabled(cleanedURL.isEmpty)  // shortenedURL boşsa butonu devre dışı bırak
                        
                        // "Tarayıcıda Aç..." butonu
                        Button("Open In Browser...") {
                            openURL(urlString: cleanedURL)
                        }
                        .padding()
                        .disabled(cleanedURL.isEmpty)  // shortenedURL boşsa butonu devre dışı bırak
                    }
                    
                }
                
                if showingNotification {
                    Text("Copied to clipboard")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(Color.white)
                        .cornerRadius(5)
                        .transition(.scale)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    self.showingNotification = false
                                }
                            }
                        }
                }
                if showingNotification {
                    // Bildirim metni ...
                }
                
                // Hata mesajını göster
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
                
                Button("Buy Me a Coffee") {
                    self.showBuyMeACoffeePopup = true
                }
                .foregroundColor(.orange)
                .padding()
                
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        NavigationLink(destination: About()) {
                            Text("About")
                        }
                        NavigationLink(destination: AppList()) {
                            Text("Supported Apps")
                        }
                        NavigationLink(destination: Request()) {
                            Text("Request")
                        }
                    } label: {
                        Label("Menu", systemImage: "line.horizontal.3")
                    }
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            // Paylaşım ekranını göster
            ActivityView(activityItems: [self.cleanedURL])
        }
        .sheet(isPresented: $showBuyMeACoffeePopup) {
            BuyMeACoffee(isPresented: $showBuyMeACoffeePopup)
        }
        .onAppear {
            //uygulama açılışında API üzerinden special host'ları çeker
            Task {
                globalSpecialHosts = await fetchSpecialHosts()
            }
        }
    }
    
    
    
    func shareButtonPressed() {
        self.showingShareSheet = true
    }
    
    
    func processAndCopyURL() {
        // Eski sonuçları ve hata mesajlarını temizle
        self.cleanedURL = ""
        self.errorMessage = ""
        self.showingNotification = false
        self.isLoading = true
        
        // URL işleme fonksiyonunu çağır
        processURL(inputURL: self.inputURL) { processedURL in
            DispatchQueue.main.async {
                if processedURL.isEmpty {
                    // Hata mesajını ayarla ve yükleniyor durumunu kapat
                    self.errorMessage = "The provided text is not in a recognized format. (Maybe missing 'http://' or 'https://' before link?)"
                    self.isLoading = false
                }
                else if processedURL == "unrecognized_format"{
                    // Hata mesajını ayarla ve yükleniyor durumunu kapat
                    self.errorMessage = "The provided link is not in a recognized format or there is nothing to trim. You can use 'Request' menu for including this format."
                    self.isLoading = false
                }
                else {
                    // temizlenmiş URL'i al ve panoya kopyala
                    self.cleanedURL = self.getShortenedURL(originalURL: processedURL)
                    UIPasteboard.general.string = self.cleanedURL
                    
                    // Yükleniyor durumunu ve bildirimi ayarla
                    self.isLoading = false
                    withAnimation {
                        self.showingNotification = true
                    }
                }
            }
        }
    }
    
    
    func processURL(inputURL: String, completion: @escaping (String) -> Void) {
        
        // textin başındaki ve sonundaki boşluğu temizle
        let trimmedURL = inputURL.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let url = URL(string: trimmedURL) else {
            completion("") // Geçersiz URL veya boş metin için boş string döndür
            return
        }
        
        //let specialHosts = ["vm.tiktok.com", "ty.gl", "amzn.eu"] // Özel URL'ler için kontrol
        
        // JSON verisini çek
        //Task {
        //    specialHosts = await fetchSpecialHosts() // Özel URL'ler için kontrol
        //}
        
        specialHosts = globalSpecialHosts
        
        if specialHosts.contains(where: { url.host?.contains($0) ?? false }) {
            resolveShortURL(url: url) { resolvedURL in
                self.processSpecialOrShortenedURL(inputURL: resolvedURL, completion: { processedURL in
                    if processedURL == trimmedURL {
                        completion("unrecognized_format")
                    } else {
                        completion(processedURL)
                    }
                })
            }
        } else {
            let processedURL = processGeneralURL(inputURL: trimmedURL)
            if processedURL == trimmedURL {
                completion("unrecognized_format")
            } else {
                completion(processedURL)
            }
        }
    }
    
    
    // Genel URL'leri işleme fonksiyonu
    func processGeneralURL(inputURL: String) -> String {
        guard let urlComponents = NSURLComponents(string: inputURL) else {
            return inputURL
        }
        // Sorgu kısmını kaldır
        urlComponents.query = nil
        // Yeni URL'yi oluştur
        return urlComponents.string ?? inputURL
    }
    
    func processSpecialOrShortenedURL(inputURL: String, completion: @escaping (String) -> Void) {
        // Özel URL'ler için ek işlem
        if inputURL.contains("p8zh") {
            guard let url = URL(string: inputURL) else {
                completion(inputURL)
                return
            }
            // resolveshorturl return yerine completion yaptığı için kodu bozdu
            //let trendyolURL = resolveShortURL(url: url, completion: completion)
            //completion(processGeneralURL(inputURL: trendyolURL))
            
        } else {
            // Genel işlem yeterliyse (örn. kısaltılmış linkler için)
            completion(processGeneralURL(inputURL: inputURL))
        }
    }
    
    func resolveShortURL(url: URL, completion: @escaping (String) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Mozilla/5.0 (iPhone; CPU iPhone OS 10_3 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) CriOS/56.0.2924.75 Mobile/14E5239e Safari/602.1", forHTTPHeaderField: "User-Agent")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                completion(url.absoluteString) // Hata varsa orijinal URL'yi döndür
                return
            }
            
            if httpResponse.statusCode == 200, let location = httpResponse.url?.absoluteString {
                // Yönlendirme varsa, yeni URL'yi kullan
                completion(location)
            } else {
                // Yönlendirme yoksa orijinal URL'yi döndür
                completion(url.absoluteString)
            }
        }
        task.resume()
    }
    
    func fetchHosts() {
        Task {
            globalSpecialHosts = await fetchSpecialHosts()
        }
    }
    
    // http request ile json dosyasını çeker
    func fetchSpecialHosts() async -> [String] {
        //guard let url = URL(string: "https://emreertunc.github.io/sneakshare_hostnames/hostnames.json")
        // üstteki orijinal link alttaki ile değiştirilerek URL'e rastgele bir sorgu parametresi ekleyerek, her istek için farklı bir URL oluşturuldu ve bu şekilde önbellek atlandı. URL'in sonuna bir timestamp eklendi.
        guard let url = URL(string: "https://emreertunc.github.io/sneakshare_hostnames/hostnames.json?timestamp=\(Date().timeIntervalSince1970)")
                
        else { return [] }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            //JSON'ı aşağıda tanımlı SpecialHosts yapısına göre decode et
            let decodedResponse = try JSONDecoder().decode(SpecialHosts.self, from: data)
            return decodedResponse.links
        } catch {
            print("JSON verisi çekilirken hata oluştu: \(error)")
            return []
        }
    }
    
    
    // temizlenmiş URL'i tarayıcıda aç
    func openURL(urlString: String) {
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    
    // Kısaltılmış URL elde etme fonksiyonu (Örnek amaçlıdır)
    func getShortenedURL(originalURL: String) -> String {
        // Burada kısaltılmış URL'i elde etmek için gereken işlemleri yap
        // Şu anlık orijinal URL'i döndürüyoruz
        return originalURL
    }
    
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// JSON Veri Modeli
struct SpecialHosts: Codable {
    var links: [String]
}
