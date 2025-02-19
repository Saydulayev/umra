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
    @ObservedObject var storeVM: StoreVM
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
        ZStack {
            // Фоновый градиент для всего экрана
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
                        .neumorphicBackground() // Применяем выделенный стиль для Picker
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
                let success = await buy(productID: selectedProductId)
                isLoading = false
                if success { isPresented = false }
            }
        } label: {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                } else {
                    Text("_donate_button", bundle: settings.bundle)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .frame(maxWidth: .infinity)
            .neumorphicBackground() // Применяем модификатор для кнопки пожертвования
            .padding()
        }
    }
    
    func buy(productID: String) async -> Bool {
        do {
            guard let product = storeVM.availableDonations.first(where: { $0.id == productID }) else {
                print("⚠️ Product \(productID) not found in availableDonations")
                return false
            }
            if try await storeVM.purchase(product) != nil {
                isPurchased = true
                // Обновляем состояние после успешной покупки:
                storeVM.completedDonations.append(product)
                return true
            }
        } catch {
            print("❌ Purchase failed: \(error.localizedDescription)")
            showError = true
        }
        return false
    }
}


//#Preview {
//    DonationSheetView()
//}
