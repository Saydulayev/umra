//
//  PayPalView.swift
//  umra
//
//  Created by Akhmed on 06.02.23.
//



import SwiftUI
import WebKit

//MARK: For Donation
struct PayPalView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        DispatchQueue.global(qos: .background).async {
            let html = "<html><head><style>body{display:flex;justify-content:center;align-items:center;height:100vh;}</style></head><body><form id='paypal-form' action='https://www.paypal.com/cgi-bin/webscr' method='post'><input type='hidden' name='cmd' value='_s-xclick'><input type='hidden' name='hosted_button_id' value='6A7Q2VXWAR2YY'><input type='submit' value='Загрузка' onclick='document.getElementById(\"paypal-form\").submit();' style='width:400px;height:150px;background-color: #4CAF50;color: white;padding: 14px 20px;margin: 8px 0;border: none;border-radius: 4px;cursor: pointer;font-size:50px;'><img alt='' border='0' src='https://www.paypal.com/en_US/i/scr/pixel.gif' width='1' height='1'></form><script>document.getElementById('paypal-form').submit();</script></body></html>"


            DispatchQueue.main.async {
                uiView.loadHTMLString(html, baseURL: nil)
            }
        }
    }
}












struct PayPalView_Previews: PreviewProvider {
    static var previews: some View {
        PayPalView()
    }
}

