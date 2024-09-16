//
//  SubscriptionView.swift
//  umra
//
//  Created by Akhmed on 06.12.23.
//

import SwiftUI
import StoreKit


struct DonationView: View {
    @EnvironmentObject var storeVM: StoreVM
    @EnvironmentObject var settings: UserSettings
    @State var isPurchased = false
    @State private var showingSheet = false

    var body: some View {
            VStack {
                Button(action: {
                    showingSheet = true
                }) {

                    HStack {
                        Image(systemName: "heart")
                            .foregroundStyle(.red)
                        Text("text_button_support_string", bundle: settings.bundle)
                            .foregroundStyle(.blue)
                        Spacer()
                    }
                    .customTextStyle()

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
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8956587315, green: 0.9328896403, blue: 1, alpha: 1))]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .ignoresSafeArea()
            
            Text("Contribution to Application Development", bundle: settings.bundle)
                .font(.system(size: 16))
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    ZStack {
                        Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                        
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.white)
                            .blur(radius: 4)
                            .offset(x: -8, y: -8)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8980392157, green: 0.933333333, blue: 1, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .padding(2)
                        
                    })
                .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 20, y: 20)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()

            VStack(alignment: .trailing) {
                Button(action: {
                    isPresented = false
                }, label: {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 22))
                        .foregroundStyle(.blue)
                })
                .padding()
                VStack {
                    Spacer()
                    HStack {
                        Text("select_the_amount", bundle: settings.bundle)
                            .foregroundStyle(.black)
                        Picker("Выберите сумму", selection: $selectedProductId) {
                            ForEach(productPrices.keys.sorted(), id: \.self) { productId in
                                Text(productPrices[productId, default: "Unknown"]).tag(productId)
                                    
                            }
                        }
                        .font(.title)
                        .padding(5)
                        .background(
                            ZStack {
                                Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                                
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(.white)
                                    .blur(radius: 4)
                                    .offset(x: -8, y: -8)
                                
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8980392157, green: 0.933333333, blue: 1, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .padding(2)
                                
                            })
                        .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 20, y: 20)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                        
                        .accentColor(.blue)
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
                    .foregroundColor(.blue)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        ZStack {
                            Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                            
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.white)
                                .blur(radius: 4)
                                .offset(x: -8, y: -8)
                            
                            RoundedRectangle(cornerRadius: 20)
                                .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8980392157, green: 0.933333333, blue: 1, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .padding(2)
                            
                        })
                    .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 20, y: 20)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding()
            }
            .padding()
        }
    
    func buy(productID: String) async {
        do {
            // Найти продукт по ID
            if let product = storeVM.availableDonations.first(where: { $0.id == productID }) {
                if try await storeVM.purchase(product) != nil {
                    isPurchased = true
                }
            }
        } catch {
            print("purchase failed")
        }
    }
}

//#Preview {
//    DonationView().environmentObject( StoreVM())
//}
