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
    var theme: AppTheme
    
    func body(content: Content) -> some View {
        let isDarkTheme = theme == .dark
        let backgroundColor = isDarkTheme ? Color(UIColor(red: 0.25, green: 0.25, blue: 0.3, alpha: 1)) : Color.white
        let gradientBottom = isDarkTheme ? theme.gradientBottomColor : Color.white
        
        return content
            .background(
                ZStack {
                    theme.primaryColor.opacity(0.1)
                    
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundColor(backgroundColor)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [theme.gradientTopColor, gradientBottom]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .padding(2)
                }
            )
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 20, y: 20)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

extension View {
    func neumorphicBackground(cornerRadius: CGFloat = 20, theme: AppTheme) -> some View {
        self.modifier(NeumorphicBackground(cornerRadius: cornerRadius, theme: theme))
    }
}

// MARK: - DonationSheetView
struct DonationSheetView: View {
    @Binding var isPresented: Bool
    @Binding var isPurchased: Bool
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(PurchaseManager.self) private var purchaseManager
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
                // Фоновый цвет для экрана
                themeManager.selectedTheme.lightBackgroundColor
                    .ignoresSafeArea()
                
                Text("Contribution to Application Development", bundle: localizationManager.bundle)
                    .font(.system(size: 16))
                    .foregroundColor(themeManager.selectedTheme.textColor)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .neumorphicBackground(theme: themeManager.selectedTheme)
                    .padding()
                
                VStack {
                    Spacer()
                    HStack {
                        Text("select_the_amount", bundle: localizationManager.bundle)
                            .foregroundStyle(themeManager.selectedTheme.textColor)
                        Picker("Выберите сумму", selection: $selectedProductId) {
                            ForEach(productPrices.keys.sorted(), id: \.self) { productId in
                                Text(productPrices[productId, default: "Unknown"]).tag(productId)
                            }
                        }
                        .font(.title)
                        .padding(5)
                        .neumorphicBackground(theme: themeManager.selectedTheme)
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
                            .foregroundStyle(themeManager.selectedTheme.primaryColor)
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
                    Text("_donate_button", bundle: localizationManager.bundle)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(themeManager.selectedTheme.textColor)
                        .padding()
                }
            }
            .frame(maxWidth: .infinity)
                        .neumorphicBackground(theme: themeManager.selectedTheme)
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
