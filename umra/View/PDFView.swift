//
//  PDFView.swift
//  umra
//
//  Created by Akhmed on 12.02.23.
//





import SwiftUI
import WebKit

struct PDFView: View {
    var body: some View {
        WebView(url: URL(string: "https://static.toislam.ws/files/biblioteka/biblioteka_pdf/05_fiqh/05_hadj/02_hadj_i_umra.pdf")!)
    }
}

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}




















struct PDFView_Previews: PreviewProvider {
    static var previews: some View {
        PDFView()
    }
}
