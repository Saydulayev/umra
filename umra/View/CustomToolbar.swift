//
//  CustomToolbar.swift
//  umra
//
//  Created by Akhmed on 07.11.23.
//

import SwiftUI
import Foundation



struct CustomToolbar: View {
    @Binding var selectedFont: String
    @Environment(ThemeManager.self) private var themeManager
    @Environment(LocalizationManager.self) private var localizationManager
    var fonts: [String]

    var body: some View {
        HStack {
            Menu {
                Picker(selection: $selectedFont, label: Text("select_font", bundle: localizationManager.bundle)) {
                    ForEach(fonts, id: \.self) { font in
                        Text(font).tag(font)
                    }
                }
            } label: {
                Label {
                    Text("select_font", bundle: localizationManager.bundle)
                } icon: {
                    Image(systemName: "textformat")
                }
                .imageScale(.large)
                .foregroundStyle(.primary)
            }
        }
    }
}

