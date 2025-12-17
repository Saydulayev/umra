//
//  MainTabView.swift
//  umra
//
//  Created on 25.01.25.
//

import SwiftUI

struct MainTabView: View {
    @Environment(LocalizationManager.self) private var localizationManager
    
    private var umraTabLabel: String {
        NSLocalizedString("tab_umra", bundle: localizationManager.bundle ?? .main, comment: "")
    }
    
    private var hajjTabLabel: String {
        NSLocalizedString("tab_hajj", bundle: localizationManager.bundle ?? .main, comment: "")
    }
    
    var body: some View {
        ZStack {
            if localizationManager.hasSelectedLanguage {
                tabViewContent
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .scale(scale: 0.9).combined(with: .opacity)
                        )
                    )
            } else {
                LanguageSelectionView()
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        )
                    )
            }
        }
        .animation(.smooth, value: localizationManager.hasSelectedLanguage)
    }
    
    @ViewBuilder
    private var tabViewContent: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label(umraTabLabel, systemImage: "u.circle.fill")
                }
            
            HajjView()
                .tabItem {
                    Label(hajjTabLabel, systemImage: "h.circle.fill")
                }
        }
        .environment(\.horizontalSizeClass, .compact)
        .onAppear {
            setupTabBarAppearance()
        }
        .toolbarBackground(.ultraThinMaterial, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }

    /// Настройка внешнего вида TabBar с blur эффектом
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        // Используем secondary цвет с прозрачностью для полупрозрачного эффекта
        appearance.backgroundColor = UIColor.secondarySystemBackground.withAlphaComponent(0.8)
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().isTranslucent = true
    }
}
