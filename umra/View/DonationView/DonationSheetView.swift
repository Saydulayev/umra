//
//  DonationSheetView.swift
//  umra
//
//  Created by Saydulayev on 19.02.25.
//

import SwiftUI
import StoreKit
import OSLog

// MARK: - Neumorphic Background Modifier

struct NeumorphicBackground: ViewModifier {
    var cornerRadius: CGFloat = 20
    var theme: AppTheme
    
    func body(content: Content) -> some View {
        return content
            .standardCardFrame(theme: theme, cornerRadius: cornerRadius)
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
    @State private var selectedProductID = ProductID.umrahSunnah1.rawValue
    @State private var isLoading = false
    @State private var showError = false
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.umra.app", category: "DonationSheetView")
    
    
    private var titlePadding: CGFloat {
        AppConstants.isIPad ? 24 : 16
    }
    
    private var titleCornerRadius: CGFloat {
        AppConstants.isIPad ? 24 : 20
    }
    
    private var pickerPadding: CGFloat {
        AppConstants.isIPad ? 12 : 5
    }
    
    private var pickerContainerPadding: CGFloat {
        AppConstants.isIPad ? 24 : 16
    }
    
    private var buttonPadding: CGFloat {
        AppConstants.isIPad ? 24 : 16
    }
    
    private var buttonCornerRadius: CGFloat {
        AppConstants.isIPad ? 24 : 20
    }
    
    private var productPrices: [String: String] {
        Dictionary(uniqueKeysWithValues: ProductID.allCases.map { ($0.rawValue, $0.displayPrice) })
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.selectedTheme.backgroundColor
                    .ignoresSafeArea()

                GeometryReader { geo in
                    ScrollView {
                        VStack(spacing: 0) {
                            Spacer()

                            Text("Contribution to Application Development", bundle: localizationManager.bundle)
                                .font(.callout.weight(.medium))
                                .foregroundStyle(themeManager.selectedTheme.textColor)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(titlePadding)
                                .frame(maxWidth: .infinity)
                                .neumorphicBackground(cornerRadius: titleCornerRadius, theme: themeManager.selectedTheme)
                                .padding(.horizontal, pickerContainerPadding)

                            Spacer()

                            VStack(spacing: AppConstants.isIPad ? 24 : 16) {
                                HStack(spacing: AppConstants.isIPad ? 16 : 12) {
                                    Text("select_the_amount", bundle: localizationManager.bundle)
                                        .font(.callout.weight(.medium))
                                        .foregroundStyle(themeManager.selectedTheme.textColor)
                                        .fixedSize(horizontal: false, vertical: true)

                                    Picker("Выберите сумму", selection: $selectedProductID) {
                                        ForEach(ProductID.allCases, id: \.rawValue) { productID in
                                            Text(productID.displayPrice)
                                                .font(.title3)
                                                .tag(productID.rawValue)
                                        }
                                    }
                                    .font(.title3)
                                    .padding(pickerPadding)
                                    .neumorphicBackground(cornerRadius: buttonCornerRadius, theme: themeManager.selectedTheme)
                                    .tint(themeManager.selectedTheme.primaryColor)
                                    .pickerStyle(MenuPickerStyle())
                                }
                                .padding(.horizontal, pickerContainerPadding)

                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: themeManager.selectedTheme.textColor))
                                        .frame(maxWidth: .infinity)
                                        .padding(buttonPadding)
                                        .neumorphicBackground(cornerRadius: buttonCornerRadius, theme: themeManager.selectedTheme)
                                        .padding(.horizontal, pickerContainerPadding)
                                } else {
                                    donateButton
                                }
                            }
                            .padding(.bottom, AppConstants.isIPad ? 40 : 32)
                        }
                        .frame(minHeight: geo.size.height)
                    }
                    .scrollBounceBehavior(.basedOnSize)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isPresented = false
                    }, label: {
                        Image(systemName: "xmark.circle")
                            .imageScale(.large)
                            .foregroundStyle(themeManager.selectedTheme.primaryColor)
                    })
                    .accessibilityLabel("Close")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .alert("Ошибка", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Покупка не удалась. Пожалуйста, попробуйте снова.")
        }
    }
    
    private var donateButton: some View {
        Button {
            Task { @MainActor in
                isLoading = true
                await buy(productID: selectedProductID)
                isLoading = false
                if isPurchased { isPresented = false }
            }
        } label: {
            Text("_donate_button", bundle: localizationManager.bundle)
                .font(.title3.weight(.medium))
                .foregroundStyle(themeManager.selectedTheme.textColor)
                .frame(maxWidth: .infinity)
                .padding(buttonPadding)
                .neumorphicBackground(cornerRadius: buttonCornerRadius, theme: themeManager.selectedTheme)
                .padding(.horizontal, pickerContainerPadding)
        }
    }
    
    /// Обработка покупки продукта
    func buy(productID: String) async {
        // Сбрасываем флаг ошибки перед началом
        showError = false
        guard let product = purchaseManager.availableDonations.first(where: { $0.id == productID }) else {
            logger.error("Продукт не найден: \(productID, privacy: .public)")
            showError = true
            return
        }
        
        do {
            try await purchaseManager.purchase(product)
            // Если после покупки продукт присутствует в списке завершённых, считаем покупку успешной
            if purchaseManager.completedDonations.contains(where: { $0.id == productID }) {
                isPurchased = true
                logger.info("Покупка успешна для продукта: \(productID, privacy: .public)")
            }
        } catch let error as PurchaseManager.PurchaseError {
            logger.error("Ошибка покупки: \(error.localizedDescription, privacy: .public)")
            showError = true
        } catch {
            logger.error("Неожиданная ошибка покупки: \(error.localizedDescription, privacy: .public)")
            showError = true
        }
    }
}


//#Preview {
//    DonationSheetView()
//}
