//
//  HajjStep3.swift
//  umra
//
//  Created on 25.01.25.
//

import SwiftUI

struct HajjStep3: View {
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager

    var body: some View {
        StepScrollView {
            // Секция: Фаджр
            Text("hajj_step3_fajr_title", bundle: localizationManager.bundle)
                .font(fontManager.sectionTitleFont)

            Group {
                Text("hajj_step3_fajr_text", bundle: localizationManager.bundle)
            }
            .font(fontManager.bodyFont)

            Divider().padding(.vertical, 8)

            // Секция: Аль-Маш'ар-аль-Харам
            Text("hajj_step3_mashaar_title", bundle: localizationManager.bundle)
                .font(fontManager.sectionTitleFont)

            Group {
                Text("hajj_step3_mashaar_text", bundle: localizationManager.bundle)
            }
            .font(fontManager.bodyFont)

            Divider().padding(.vertical, 8)

            // Секция: Мина
            Text("hajj_step3_mina_title", bundle: localizationManager.bundle)
                .font(fontManager.sectionTitleFont)

            Group {
                Text("hajj_step3_mina_text", bundle: localizationManager.bundle)
            }
            .font(fontManager.bodyFont)

            Divider().padding(.vertical, 8)

            // Секция: Бросание камешков
            Text("hajj_step3_jamarat_title", bundle: localizationManager.bundle)
                .font(fontManager.sectionTitleFont)

            Group {
                Text("hajj_step3_jamarat_text", bundle: localizationManager.bundle)
            }
            .font(fontManager.bodyFont)

            Divider().padding(.vertical, 8)

            // Секция: Частичный выход
            Text("hajj_step3_partial_exit_title", bundle: localizationManager.bundle)
                .font(fontManager.sectionTitleFont)

            Group {
                Text("hajj_step3_partial_exit_text", bundle: localizationManager.bundle)
            }
            .font(fontManager.bodyFont)

            Divider().padding(.vertical, 8)

            // Секция: Жертвоприношение
            Text("hajj_step3_sacrifice_title", bundle: localizationManager.bundle)
                .font(fontManager.sectionTitleFont)

            Group {
                Text("hajj_step3_sacrifice_text", bundle: localizationManager.bundle)
            }
            .font(fontManager.bodyFont)

            Divider().padding(.vertical, 8)

            // Секция: Бритьё
            Text("hajj_step3_shaving_title", bundle: localizationManager.bundle)
                .font(fontManager.sectionTitleFont)

            Group {
                Text("hajj_step3_shaving_text", bundle: localizationManager.bundle)
            }
            .font(fontManager.bodyFont)

            Divider().padding(.vertical, 8)

            // Секция: Таваф
            Text("hajj_step3_tawaf_title", bundle: localizationManager.bundle)
                .font(fontManager.sectionTitleFont)

            Group {
                Text("hajj_step3_tawaf_text", bundle: localizationManager.bundle)
            }
            .font(fontManager.bodyFont)

            Divider().padding(.vertical, 8)

            // Секция: Внимание
            Text("hajj_step3_attention_title", bundle: localizationManager.bundle)
                .font(fontManager.sectionTitleFont)

            Group {
                Text("hajj_step3_attention_text", bundle: localizationManager.bundle)
            }
            .font(fontManager.bodyFont)

            Divider().padding(.vertical, 8)

            // Секция: Полный выход
            Text("hajj_step3_full_exit_title", bundle: localizationManager.bundle)
                .font(fontManager.sectionTitleFont)

            Group {
                Text("hajj_step3_full_exit_text", bundle: localizationManager.bundle)
            }
            .font(fontManager.bodyFont)

            Divider().padding(.vertical, 8)

            // Секция: Возвращение
            Text("hajj_step3_return_title", bundle: localizationManager.bundle)
                .font(fontManager.sectionTitleFont)

            Group {
                Text("hajj_step3_return_text", bundle: localizationManager.bundle)
            }
            .font(fontManager.bodyFont)
        }
    }
}
