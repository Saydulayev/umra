//
//  DonateButton.swift
//  umra
//
//  Created by Akhmed on 02.02.23.
//

import SwiftUI
import WebKit

struct CloseButton: View {
    
    @Binding var showDestinationView: Bool
    
    var body: some View {
        VStack {
            PayPalView()
            
            Button(action: {
                self.showDestinationView = false
            }) {
                HStack {
                    Image(systemName: "xmark.square")
                    Text("Закрыть")
                } .foregroundColor(.green)
            }
        }
    }
}

struct DonationButton: View {
    
    @State private var showDestinationView = false
    
    var body: some View {
        VStack {
            
            
            VStack {
                Button(action: {
                    self.showDestinationView.toggle()
                }) {
                    VStack {
                        VStack {
                            Text("Поддержать разработчика")
                                .foregroundColor(.blue)
                        }
                    }
                }
               
                    
                if showDestinationView {
                    CloseButton(showDestinationView: $showDestinationView)
                }
            }
            .sheet(isPresented: $showDestinationView) {
                CloseButton(showDestinationView: $showDestinationView)
            }
        }
    }
}



struct DonationButton_Previews: PreviewProvider {
    static var previews: some View {
        DonationButton()
    }
}

