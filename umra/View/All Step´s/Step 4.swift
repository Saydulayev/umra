//
//  Step 4.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct Step4: View {
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager

    var body: some View {
        StepScrollView {
            Text("Drinking Zamzam water.", bundle: localizationManager.bundle)
                .font(fontManager.sectionTitleFont)

            Group {
                Text("Zamzam text", bundle: localizationManager.bundle)
            }
            .font(fontManager.bodyFont)
        }
    }
}
