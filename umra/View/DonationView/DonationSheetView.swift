//
//  DonationSheetView.swift
//  umra
//
//  Created by Saydulayev on 19.02.25.
//

import SwiftUI
import StoreKit

// MARK: - Neumorphic Background Modifier

struct NeumorphicBackground: ViewModifier {
    var cornerRadius: CGFloat = 20
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    Color(red: 0.76, green: 0.82, blue: 0.93)
                    
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundColor(.white)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 0.90, green: 0.93, blue: 1.0), Color.white]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .padding(2)
                }
            )
            .shadow(color: Color(red: 0.76, green: 0.82, blue: 0.93), radius: 20, x: 20, y: 20)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

extension View {
    func neumorphicBackground(cornerRadius: CGFloat = 20) -> some View {
        self.modifier(NeumorphicBackground(cornerRadius: cornerRadius))
    }
}

// MARK: - DonationSheetView
struct DonationSheetView: View {
    @Binding var isPresented: Bool
    @Binding var isPurchased: Bool
    @EnvironmentObject var settings: UserSettings
    @ObservedObject var purchaseManager: PurchaseManager
    @State private var selectedProductId = "UmrahSunnah1"
    @State private var isLoading = false
    @State private var showError = false
    
    let productPrices: [String: String] = [
        "UmrahSunnah1": "$0.99",
        "UmrahSunnah2": "$4.99",
        "UmrahSunnah3": "$9.99",
        "UmrahSunnah4": "$19.99",
        "UmrahSunnah5": "$49.99",
        "UmrahSunnah6": "$99.99"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Фоновый градиент для экрана
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(red: 0.90, green: 0.93, blue: 1.0)]),
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
                    .neumorphicBackground()
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
                        .neumorphicBackground()
                        .padding()
                        .accentColor(.blue)
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        donateButton
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isPresented = false
                    }, label: {
                        Image(systemName: "xmark.circle")
                            .imageScale(.large)
                            .foregroundStyle(.blue)
                    })
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"),
                  message: Text("Purchase failed. Please try again."),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    private var donateButton: some View {
        Button {
            Task {
                isLoading = true
                await buy(productID: selectedProductId)
                isLoading = false
                if isPurchased { isPresented = false }
            }
        } label: {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .padding()
                } else {
                    Text("_donate_button", bundle: settings.bundle)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .frame(maxWidth: .infinity)
            .neumorphicBackground()
            .padding()
        }
    }
    
    func buy(productID: String) async {
        // Сбрасываем флаг ошибки перед началом
        showError = false
        guard let product = purchaseManager.availableDonations.first(where: { $0.id == productID }) else {
            print("⚠️ Product \(productID) not found")
            return
        }
        await purchaseManager.purchase(product)
        // Если после покупки продукт присутствует в списке завершённых, считаем покупку успешной
        if purchaseManager.completedDonations.contains(where: { $0.id == productID }) {
            isPurchased = true
        } else if purchaseManager.purchaseError != nil {
            showError = true
        }
    }
}


//#Preview {
//    DonationSheetView()
//}
