//
//  CustomToolbar.swift
//  umra
//
//  Created by Akhmed on 07.11.23.
//

import SwiftUI



struct CustomToolbar: View {
    @Binding var selectedFont: String
    @Binding var backgroundColor: Color
    @Binding var textColor: Color
    @EnvironmentObject var settings: UserSettings
    var fonts: [String]

    var body: some View {
        HStack {
            Menu {
                Picker(selection: $selectedFont, label: Text("Select a Font")) {
                    ForEach(fonts, id: \.self) { font in
                        Text(font).tag(font)
                    }
                }
            } label: {
                Image(systemName: "textformat").imageScale(.large).foregroundColor(.primary)
            }
        }
    }
}

