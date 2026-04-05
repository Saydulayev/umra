//
//  Step 5.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct Step5: View {
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager

    var body: some View {
        StepScrollView {
            Text("Return to the Black Stone.", bundle: localizationManager.bundle)
                .font(fontManager.sectionTitleFont)

            Group {
                Text("Return to the Black Stone, recite the Takbir.", bundle: localizationManager.bundle)
                Spacer()

                Text("Allah is great.", bundle: localizationManager.bundle)
                Text("الله أكبر‎")
                    .customTextforArabic()

                PlayerView(fileName: "6")
            }
            .font(fontManager.bodyFont)
        }
    }
}
