//
//  Step 7.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct Step7: View {
    @Environment(LocalizationManager.self) private var localizationManager
    @Environment(FontManager.self) private var fontManager

    var body: some View {
        StepScrollView {
            Text("Shaving the head string", bundle: localizationManager.bundle)
                .font(fontManager.sectionTitleFont)

            Group {
                Text("Men shorten or shave their hair.", bundle: localizationManager.bundle)
                Text("Du'a at the end.", bundle: localizationManager.bundle)
            }
            .font(fontManager.bodyFont)
        }
    }
}
