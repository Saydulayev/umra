//
//  MainTabView.swift
//  umra
//
//  Created on 25.01.25.
//

import SwiftUI

struct MainTabView: View {
    @Environment(ThemeManager.self) private var themeManager
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
        let bgColor = UIColor(themeManager.selectedTheme.cardColor).withAlphaComponent(0.85)
        appearance.backgroundColor = bgColor
        
        let emerald = UIColor(themeManager.selectedTheme.primaryColor)
        let normal = UIColor(themeManager.selectedTheme.textColor).withAlphaComponent(0.4)
        appearance.stackedLayoutAppearance.selected.iconColor = emerald
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: emerald]
        appearance.stackedLayoutAppearance.normal.iconColor = normal
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: normal]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().isTranslucent = true
    }
}
