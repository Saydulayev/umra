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
        .onChange(of: themeManager.themePreference) {
            setupTabBarAppearance()
        }
    }

    private func setupTabBarAppearance() {
        let isDark = themeManager.selectedTheme.isDarkAppearance
        let blurStyle: UIBlurEffect.Style = isDark ? .systemUltraThinMaterialDark : .systemUltraThinMaterialLight

        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: blurStyle)
        appearance.backgroundColor = UIColor(themeManager.selectedTheme.cardColor).withAlphaComponent(0.85)

        let primary = UIColor(themeManager.selectedTheme.primaryColor)
        let inactive = UIColor(themeManager.selectedTheme.textColor).withAlphaComponent(0.4)
        appearance.stackedLayoutAppearance.selected.iconColor = primary
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: primary]
        appearance.stackedLayoutAppearance.normal.iconColor = inactive
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: inactive]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().isTranslucent = true

        // UITabBar.appearance() применяется только к новым инстансам,
        // поэтому обновляем существующий UITabBar напрямую.
        for scene in UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }) {
            for window in scene.windows {
                updateTabBar(in: window.rootViewController, appearance: appearance)
            }
        }
    }

    private func updateTabBar(in vc: UIViewController?, appearance: UITabBarAppearance) {
        guard let vc else { return }
        if let tabBarVC = vc as? UITabBarController {
            tabBarVC.tabBar.standardAppearance = appearance
            tabBarVC.tabBar.scrollEdgeAppearance = appearance
        }
        vc.children.forEach { updateTabBar(in: $0, appearance: appearance) }
        updateTabBar(in: vc.presentedViewController, appearance: appearance)
    }
}
