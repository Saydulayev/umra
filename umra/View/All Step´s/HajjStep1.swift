//
//  HajjStep1.swift
//  umra
//
//  Created on 25.01.25.
//

import SwiftUI

struct HajjStep1: View {
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager

    var body: some View {
        StepScrollView {
            // Секция: Подготовка к ихраму
            Text("preparation_before_ihram_title", bundle: localizationManager.bundle)
                .font(fontManager.sectionTitleFont)

            Group {
                Text("preparation_before_ihram_text", bundle: localizationManager.bundle)
            }
            .font(fontManager.bodyFont)

            Divider()
                .padding(.vertical, 8)

            // Секция: Ихрам
            Text("hajj_step1_ihram_title", bundle: localizationManager.bundle)
                .font(fontManager.sectionTitleFont)

            Group {
                VStack(alignment: .leading, spacing: 10) {
                    Text("hajj_step1_ihram_text", bundle: localizationManager.bundle)
                        .font(fontManager.bodyFont)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("hajj_step1_ihram_arabic", bundle: localizationManager.bundle)
                            .customTextforArabic()
                            .padding(.top, 4)
                            .padding(.bottom, 16)

                        PlayerView(fileName: "14")

                        Text("hajj_step1_ihram_transliteration", bundle: localizationManager.bundle)
                            .font(fontManager.bodyFont)
                            .italic()

                        Text("hajj_step1_ihram_translation", bundle: localizationManager.bundle)
                            .font(fontManager.bodyFont)
                    }
                    .padding(.leading, 12)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("hajj_step1_ihram_dua_arabic", bundle: localizationManager.bundle)
                            .customTextforArabic()
                            .padding(.top, 8)
                            .padding(.bottom, 16)

                        PlayerView(fileName: "15")

                        Text("hajj_step1_ihram_dua_transliteration", bundle: localizationManager.bundle)
                            .font(fontManager.bodyFont)
                            .italic()

                        Text("hajj_step1_ihram_dua_translation", bundle: localizationManager.bundle)
                            .font(fontManager.bodyFont)
                    }
                    .padding(.leading, 12)
                }
            }
            .font(fontManager.bodyFont)

            Divider()
                .padding(.vertical, 8)

            // Секция: Тальбия
            Text("hajj_step1_talbiyah_title", bundle: localizationManager.bundle)
                .font(fontManager.sectionTitleFont)

            Group {
                VStack(alignment: .leading, spacing: 10) {
                    Text("hajj_step1_talbiyah_text", bundle: localizationManager.bundle)
                        .font(fontManager.bodyFont)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("hajj_step1_talbiyah_arabic", bundle: localizationManager.bundle)
                            .customTextforArabic()
                            .padding(.top, 4)
                            .padding(.bottom, 16)

                        PlayerView(fileName: "3")

                        Text("hajj_step1_talbiyah_transliteration", bundle: localizationManager.bundle)
                            .font(fontManager.bodyFont)
                            .italic()

                        Text("hajj_step1_talbiyah_translation", bundle: localizationManager.bundle)
                            .font(fontManager.bodyFont)
                    }
                    .padding(.leading, 12)
                }
            }
            .font(fontManager.bodyFont)

            Divider()
                .padding(.vertical, 8)

            // Секция: Мина
            Text("hajj_step1_mina_title", bundle: localizationManager.bundle)
                .font(fontManager.sectionTitleFont)

            Group {
                Text("hajj_step1_mina_text", bundle: localizationManager.bundle)
            }
            .font(fontManager.bodyFont)
        }
    }
}
