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
    @State private var isLoading = false
    
    let productPrices: [String: String] = [
        "UmrahSunnah1": "$0,99",
        "UmrahSunnah2": "$4,99",
        "UmrahSunnah3": "$9,99",
        "UmrahSunnah4": "$19,99",
        "UmrahSunnah5": "$49,99",
        "UmrahSunnah6": "$99,99"
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            Text("Contribution to Application Development", bundle: settings.bundle)
                .font(.system(size: 14))
                .foregroundStyle(.primary)
                .padding(10)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(10)

            VStack(alignment: .trailing) {
                Button(action: {
                    isPresented = false
                }, label: {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 22))
                })
                .padding()
                VStack {
                    Spacer()
                    HStack {
                        Text("select_the_amount", bundle: settings.bundle)
                            .foregroundStyle(.white)
                        Picker("Выберите сумму", selection: $selectedProductId) {
                            ForEach(productPrices.keys.sorted(), id: \.self) { productId in
                                Text(productPrices[productId, default: "Unknown"]).tag(productId)
                                    
                            }
                        }
                        .font(.title)
                        .padding(5)
                        .background(.blue.opacity(0.7))
                        .clipShape(Capsule())
                        
                        .accentColor(.white)
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                    } else {
                        donateButton
                    }
                }
            }
        }
    }
    
    private var donateButton: some View {
            Button {
                Task {
                    isLoading = true
                    await buy(productID: selectedProductId)
                    isLoading = false
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
