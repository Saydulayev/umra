//
//  SettingsView.swift
//  umra
//
//  Created by Akhmed on 08.04.23.
//

import SwiftUI
import SafariServices

struct SettingsView: View {
    @State private var showSafariView = false
    @State private var showPicker = false
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Feedback")) {
                    Image(systemName: "message")
                        .foregroundColor(.blue)
                    Button(action: {
                        if let url = URL(string: "mailto:saydulayev.wien@gmail.com") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Text("Обратная связь")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Section(header: Text("Evaluate the app")) {
                    Image(systemName: "star")
                        .foregroundColor(.yellow)
                    Button("Оценить приложение") {
                        showSafariView.toggle()
                    } .foregroundColor(.blue)
                }
                
                Section(header: Text("Support the developer")) {
                    Image(systemName: "heart")
                        .foregroundColor(.red)
                    Button(action: {
                        
                    }) {
                        DonationButton()
                    }
                }
            }
        }
        .navigationBarTitle("Настройки", displayMode: .inline)
        .sheet(isPresented: $showSafariView) {
            SafariView(url: URL(string: "https://apps.apple.com/app/id1673683355")!)
        }
    }
}


struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariView = SFSafariViewController(url: url)
        return safariView
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
