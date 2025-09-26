//
//  DonationSheetView.swift
//  umra
//
//  Created by Saydulayev on 19.02.25.
//

import SwiftUI
import StoreKit
import UIKit

// MARK: - Glass Utilities (прозрачное стекло)

private let glassStrokeGradient = LinearGradient(
    colors: [Color.white.opacity(0.75), Color.white.opacity(0.20)],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)

// Всегда "светлый" блюр, независимо от темы устройства
private struct LightBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let effect: UIBlurEffect
        if #available(iOS 13.0, *) {
            effect = UIBlurEffect(style: .systemThinMaterialLight)
        } else {
            effect = UIBlurEffect(style: .light)
        }
        return UIVisualEffectView(effect: effect)
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) { }
}

@ViewBuilder
private func glassRoundedBackground(cornerRadius: CGFloat) -> some View {
    LightBlurView()
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
}

private func glassRoundedStroke(cornerRadius: CGFloat, lineWidth: CGFloat = 1) -> some View {
    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        .strokeBorder(glassStrokeGradient, lineWidth: lineWidth)
}

private func glassRoundedHighlight(cornerRadius: CGFloat) -> some View {
    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        .fill(
            LinearGradient(
                colors: [Color.white.opacity(0.28), .clear],
                startPoint: .topLeading,
                endPoint: .center
            )
        )
        .blur(radius: 10)
        .allowsHitTesting(false)
}

private struct GlassShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.10), radius: 18, x: 0, y: 10)
            .shadow(color: Color.white.opacity(0.12), radius: 1, x: 0, y: 1)
    }
}

extension View {
    func glassContainer(cornerRadius: CGFloat) -> some View {
        self
            .background(glassRoundedBackground(cornerRadius: cornerRadius))
            .overlay(glassRoundedStroke(cornerRadius: cornerRadius))
            .overlay(glassRoundedHighlight(cornerRadius: cornerRadius))
            .modifier(GlassShadowModifier())
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

// MARK: - Pressable Glass Button Style

struct GlassPressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.85), value: configuration.isPressed)
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
        ZStack {
            // Фон экрана с лёгким градиентом
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)),
                            Color(#colorLiteral(red: 0.835, green: 0.88, blue: 0.98, alpha: 1))
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .ignoresSafeArea()
            
            // Центрирование основного блока по вертикали
            VStack {
                Spacer(minLength: 0)
                
                // Основной стеклянный блок
                VStack(spacing: 18) {
                    // Заголовок
                    Spacer()
                    Text("Contribution to Application Development", bundle: settings.bundle)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .glassContainer(cornerRadius: 18)
                    Spacer()
                    // Выбор суммы
                    VStack(spacing: 12) {
                        HStack {
                            Text("select_the_amount", bundle: settings.bundle)
                                .foregroundColor(.black)
                                .font(.body)
                            Spacer(minLength: 8)
                            Picker("Выберите сумму", selection: $selectedProductId) {
                                ForEach(productPrices.keys.sorted(), id: \.self) { productId in
                                    Text(productPrices[productId, default: "Unknown"]).tag(productId)
                                }
                            }
                            .labelsHidden()
                            .tint(.blue)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .background(glassRoundedBackground(cornerRadius: 14))
                            .overlay(glassRoundedStroke(cornerRadius: 14))
                            .overlay(glassRoundedHighlight(cornerRadius: 14))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                    }
                    .padding(.horizontal, 6)
                    .glassContainer(cornerRadius: 18)
                    
                    // Кнопка пожертвования или индикатор загрузки
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
                            .glassContainer(cornerRadius: 18)
                    } else {
                        donateButton
                    }
                }
                .foregroundColor(.black)
                .padding(.vertical)
                .padding(.horizontal, 20)
                .glassContainer(cornerRadius: 24)
                .padding()
                
                Spacer(minLength: 0)
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
                await buy(productID: selectedProductId)
                isLoading = false
                if isPurchased { isPresented = false }
            }
        } label: {
            Text("_donate_button", bundle: settings.bundle)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.blue)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity)
                .glassContainer(cornerRadius: 18)
        }
        .buttonStyle(GlassPressButtonStyle())
        .padding(.top, 4)
    }
    
    func buy(productID: String) async {
        showError = false
        guard let product = purchaseManager.availableDonations.first(where: { $0.id == productID }) else {
            print("⚠️ Product \(productID) not found")
            return
        }
        await purchaseManager.purchase(product)
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
