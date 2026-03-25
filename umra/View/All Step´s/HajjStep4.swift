//
//  HajjStep4.swift
//  umra
//
//  Created on 25.01.25.
//

import SwiftUI

struct HajjStep4: View {
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager

    var body: some View {
        StepScrollView {
            // Секция: Пребывание в Мине
            Text("hajj_step4_stay_title", bundle: localizationManager.bundle)
                .font(fontManager.sectionTitleFont)

            Group {
                Text("hajj_step4_stay_text", bundle: localizationManager.bundle)
            }
            .font(fontManager.bodyFont)

            Divider()
                .padding(.vertical, 8)

            // Секция: Бросание камешков
            Text("hajj_step4_jamarat_title", bundle: localizationManager.bundle)
                .font(fontManager.sectionTitleFont)

            Group {
                Text("hajj_step4_jamarat_text", bundle: localizationManager.bundle)
            }
            .font(fontManager.bodyFont)
        }
    }
}
