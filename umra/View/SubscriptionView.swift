//
//  SubscriptionView.swift
//  umra
//
//  Created by Akhmed on 06.12.23.
//

import SwiftUI
import StoreKit


struct SubscriptionView: View {
    @EnvironmentObject var storeVM: StoreVM
    @EnvironmentObject var settings: UserSettings
    @State var isPurchased = false
    @State private var showingSheet = false

    var body: some View {
            VStack {
                Button(action: {
                    showingSheet = true
                }) {
                    Text("text_button_support_string", bundle: settings.bundle)
                        .foregroundColor(.blue)
                }
                .sheet(isPresented: $showingSheet) {
                    DonationSheetView(isPresented: $showingSheet, isPurchased: $isPurchased, storeVM: storeVM)
                }
            }
        }
    }


struct DonationSheetView: View {
    @Binding var isPresented: Bool
    @Binding var isPurchased: Bool
    @EnvironmentObject var settings: UserSettings
    @ObservedObject var storeVM: StoreVM
    @State private var selectedProductId = "UmrahSunnah1"
    
    let productPrices: [String: String] = [
        "UmrahSunnah1": "$0,99",
        "UmrahSunnah2": "$4,99",
        "UmrahSunnah3": "$9,99",
        "UmrahSunnah4": "$19,99",
        "UmrahSunnah5": "$49,99",
        "UmrahSunnah6": "$99,99"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                RadialGradient(stops: [
                    .init(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), location: 0.3),
                    .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), location: 0.3),
                ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
                VStack {
                    Text("text_button_support_string", bundle: settings.bundle)
                        .font(.custom("Lato-Black", size: 38))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .padding(10)
                    Spacer()
                    
                    HStack {
                        Text("select_the_amount", bundle: settings.bundle)
                            .foregroundStyle(.white)
                        Picker("Выберите сумму", selection: $selectedProductId) {
                            ForEach(productPrices.keys.sorted(), id: \.self) { productId in
                                Text(productPrices[productId, default: "Unknown"]).tag(productId)
                                    .font(.title)
                            }
                        }
                        
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    
                    Button {
                        Task {
                            await buy(productID: selectedProductId)
                            isPresented = false
                        }
                    } label: {
                        Text("_donate_button", bundle: settings.bundle)
                            .font(.system(size: 18, weight: .medium, design: .default))
                            .padding()
                            .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color.blue.opacity(0.2))
                            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 10, y: 10)
                            .clipShape(Capsule())
                        
                    }
                    .padding()
                    
                }
                .toolbar {
                    Button(action: {
                        isPresented = false
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                }
            }
        }
    }
    
    func buy(productID: String) async {
        do {
            // Найти продукт по ID
            if let product = storeVM.subscriptions.first(where: { $0.id == productID }) {
                if try await storeVM.purchase(product) != nil {
                    isPurchased = true
                }
            }
        } catch {
            print("purchase failed")
        }
    }
}

#Preview {
    SubscriptionView().environmentObject( StoreVM())
}
