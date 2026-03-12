//
//  MainTabView.swift
//  umra
//
//  Created on 25.01.25.
//

import SwiftUI

enum MainTab: String, CaseIterable {
    case umra
    case hajj
}

struct MainTabView: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @State private var selectedTab: MainTab = .umra

    private var umraTabLabel: String {
        localizationManager.localized("tab_umra")
    }

    private var hajjTabLabel: String {
        localizationManager.localized("tab_hajj")
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
        TabView(selection: $selectedTab) {
            ContentView()
                .tabItem {
                    Label(umraTabLabel, systemImage: "u.circle.fill")
                }
                .tag(MainTab.umra)

            HajjView()
                .tabItem {
                    Label(hajjTabLabel, systemImage: "h.circle.fill")
                }
                .tag(MainTab.hajj)
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
