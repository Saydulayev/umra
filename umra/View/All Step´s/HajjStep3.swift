//
//  HajjStep3.swift
//  umra
//
//  Created on 25.01.25.
//

import SwiftUI

struct HajjStep3: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager
    @Bindable private var bindableFontManager: FontManager
    
    init() {
        self._bindableFontManager = Bindable(FontManager())
    }
    
    private func syncFontManager() {
        if bindableFontManager.selectedFont != fontManager.selectedFont {
            fontManager.selectedFont = bindableFontManager.selectedFont
        }
    }
    
    var body: some View {
        ZStack {
            themeManager.selectedTheme.lightBackgroundColor
                .ignoresSafeArea(edges: .bottom)
            
            ScrollView {
                VStack {
                    Group {
                        Text("hajj_step3_fajr_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: 26))
                        
                        Text("hajj_step3_fajr_text", bundle: localizationManager.bundle)
                    }
                    
                    Group {
                        Text("hajj_step3_mashaar_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: 26))
                        
                        Text("hajj_step3_mashaar_text", bundle: localizationManager.bundle)
                    }
                    
                    Group {
                        Text("hajj_step3_mina_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: 26))
                        
                        Text("hajj_step3_mina_text", bundle: localizationManager.bundle)
                    }
                    
                    Group {
                        Text("hajj_step3_jamarat_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: 26))
                        
                        Text("hajj_step3_jamarat_text", bundle: localizationManager.bundle)
                    }
                    
                    Group {
                        Text("hajj_step3_partial_exit_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: 26))
                        
                        Text("hajj_step3_partial_exit_text", bundle: localizationManager.bundle)
                    }
                    
                    Group {
                        Text("hajj_step3_sacrifice_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: 26))
                        
                        Text("hajj_step3_sacrifice_text", bundle: localizationManager.bundle)
                    }
                    
                    Group {
                        Text("hajj_step3_shaving_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: 26))
                        
                        Text("hajj_step3_shaving_text", bundle: localizationManager.bundle)
                    }
                    
                    Group {
                        Text("hajj_step3_tawaf_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: 26))
                        
                        Text("hajj_step3_tawaf_text", bundle: localizationManager.bundle)
                    }
                    
                    Group {
                        Text("hajj_step3_full_exit_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: 26))
                        
                        Text("hajj_step3_full_exit_text", bundle: localizationManager.bundle)
                    }
                    
                    Group {
                        Text("hajj_step3_return_title", bundle: localizationManager.bundle)
                            .font(.custom("Lato-Black", size: 26))
                        
                        Text("hajj_step3_return_text", bundle: localizationManager.bundle)
                    }
                }
                .font(fontManager.selectedFont == "Lato-Black" ? .system(size: fontManager.dynamicFontSize, weight: .light, design: .serif).italic() : .custom(fontManager.selectedFont, size: fontManager.dynamicFontSize))
                .foregroundStyle(.black)
                .padding(.horizontal, 10)
                LanguageView()
                    .hidden()
                    .navigationTitle(Text("hajj_step3_title", bundle: localizationManager.bundle))
                    .navigationBarTitleDisplayMode(.inline)
            }
            .onAppear {
                syncFontManager()
            }
            .onChange(of: bindableFontManager.selectedFont) { _, newFont in
                fontManager.selectedFont = newFont
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    CustomToolbar(
                        selectedFont: $bindableFontManager.selectedFont,
                        fonts: bindableFontManager.fonts
                    )
                    .environment(themeManager)
                }
            }
        }
    }
}

