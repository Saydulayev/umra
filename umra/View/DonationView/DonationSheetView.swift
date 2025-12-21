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
    @State private var selectedProductID = ProductID.umrahSunnah1.rawValue
    @State private var isLoading = false
    @State private var showError = false
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.umra.app", category: "DonationSheetView")
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private var titleFontSize: CGFloat {
        isIPad ? 24 : 16
    }
    
    private var titlePadding: CGFloat {
        isIPad ? 24 : 16
    }
    
    private var titleCornerRadius: CGFloat {
        isIPad ? 24 : 20
    }
    
    private var pickerFontSize: CGFloat {
        isIPad ? 28 : 20
    }
    
    private var pickerPadding: CGFloat {
        isIPad ? 12 : 5
    }
    
    private var pickerContainerPadding: CGFloat {
        isIPad ? 24 : 16
    }
    
    private var buttonFontSize: CGFloat {
        isIPad ? 24 : 18
    }
    
    private var buttonPadding: CGFloat {
        isIPad ? 24 : 16
    }
    
    private var buttonCornerRadius: CGFloat {
        isIPad ? 24 : 20
    }
    
    private var productPrices: [String: String] {
        Dictionary(uniqueKeysWithValues: ProductID.allCases.map { ($0.rawValue, $0.displayPrice) })
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Фоновый цвет для экрана
                themeManager.selectedTheme.lightBackgroundColor
                    .ignoresSafeArea()
                
                if isIPad {
                    // Улучшенная структура для iPad
                    VStack(spacing: 32) {
                        // Заголовок
                        Text("Contribution to Application Development", bundle: localizationManager.bundle)
                            .font(.system(size: titleFontSize, weight: .medium))
                            .foregroundColor(themeManager.selectedTheme.textColor)
                            .padding(titlePadding)
                            .frame(maxWidth: .infinity)
                            .neumorphicBackground(cornerRadius: titleCornerRadius, theme: themeManager.selectedTheme)
                            .padding(.horizontal, pickerContainerPadding)
                            .padding(.top, 24)
                        
                        Spacer()
                        
                        VStack(spacing: 24) {
                            // Выбор суммы пожертвования
                            HStack(spacing: 16) {
                                Text("select_the_amount", bundle: localizationManager.bundle)
                                    .font(.system(size: titleFontSize, weight: .medium))
                                    .foregroundStyle(themeManager.selectedTheme.textColor)
                                
                                Picker("Выберите сумму", selection: $selectedProductID) {
                                    ForEach(ProductID.allCases, id: \.rawValue) { productID in
                                        Text(productID.displayPrice)
                                            .font(.system(size: pickerFontSize))
                                            .tag(productID.rawValue)
                                    }
                                }
                                .font(.system(size: pickerFontSize))
                                .padding(pickerPadding)
                                .neumorphicBackground(cornerRadius: buttonCornerRadius, theme: themeManager.selectedTheme)
                                .accentColor(.blue)
                                .pickerStyle(MenuPickerStyle())
                            }
                            .padding(.horizontal, pickerContainerPadding)
                            
                            // Кнопка пожертвования или индикатор загрузки
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                    .frame(maxWidth: .infinity)
                                    .padding(buttonPadding)
                                    .neumorphicBackground(cornerRadius: buttonCornerRadius, theme: themeManager.selectedTheme)
                                    .padding(.horizontal, pickerContainerPadding)
                                    .padding(.bottom, 32)
                            } else {
                                donateButton
                                    .padding(.bottom, 32)
                            }
                        }
                    }
                } else {
                    // Оригинальная структура для iPhone
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
                            Picker("Выберите сумму", selection: $selectedProductID) {
                                ForEach(ProductID.allCases, id: \.rawValue) { productID in
                                    Text(productID.displayPrice).tag(productID.rawValue)
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
                            donateButtonOriginal
                        }
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
            Alert(title: Text("Ошибка"),
                  message: Text("Покупка не удалась. Пожалуйста, попробуйте снова."),
                  dismissButton: .default(Text("OK")))
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
                .font(.system(size: buttonFontSize, weight: .medium))
                .foregroundColor(themeManager.selectedTheme.textColor)
                .frame(maxWidth: .infinity)
                .padding(buttonPadding)
                .neumorphicBackground(cornerRadius: buttonCornerRadius, theme: themeManager.selectedTheme)
                .padding(.horizontal, pickerContainerPadding)
        }
    }
    
    private var donateButtonOriginal: some View {
        Button {
            Task { @MainActor in
                isLoading = true
                await buy(productID: selectedProductID)
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
