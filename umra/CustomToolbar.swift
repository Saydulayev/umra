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
                Image(systemName: "textformat")
            }

            ColorPicker("", selection: $backgroundColor)
            ColorPicker("", selection: $textColor)
        }
    }
}



//struct CustomToolbar: View {
//    @Binding var selectedFont: String
//    @Binding var selectedFontSize: CGFloat
//    @Binding var backgroundColor: Color
//    @Binding var textColor: Color
//    @EnvironmentObject var settings: UserSettings
//    @EnvironmentObject var fontManager: FontManager
//    var fonts: [String]
//    var fontSizes: [CGFloat] = [14, 16, 18, 20, 22, 24, 26]
//
//    var body: some View {
//        HStack {
//            Menu {
//                Menu {
//                    Picker("", selection: $selectedFont) {
//                        ForEach(fonts, id: \.self) { font in
//                            Text(font).tag(font)
//                        }
//                    }
//                } label: {
//                    Text("_font_", bundle: settings.bundle)
//                }
//
//                Menu {
//                    Picker("Выберите размер шрифта", selection: $fontManager.selectedFontSize) {
//                        ForEach([14, 16, 18, 20, 22, 24, 26], id: \.self) { size in
//                            Text("\(Int(size)) pt").tag(CGFloat(size))
//                        }
//                    }
//
//                } label: {
//                    Text("_size_", bundle: settings.bundle)
//                }
//            } label: {
//                Image(systemName: "textformat")
//            }
//
//            ColorPicker("", selection: $backgroundColor)
//            ColorPicker("", selection: $textColor)
//        }
//    }
//}



//    .toolbar {
//        ToolbarItemGroup(placement: .navigationBarTrailing) {
//            Menu {
//                Menu {
//                    Picker("Выберите шрифт", selection: $fontManager.selectedFont) {
//                        ForEach(fontManager.fonts, id: \.self) { font in
//                            Text(font).tag(font)
//                        }
//                    }
//                } label: {
//                    Text("_font_", bundle: settings.bundle)
//                }
//                
//                Menu {
//                    Picker("Выберите размер шрифта", selection: $fontManager.selectedFontSize) {
//                        ForEach([14, 16, 18, 20, 22, 24, 26], id: \.self) { size in
//                            Text("\(size) pt").tag(CGFloat(size))
//                        }
//                    }
//                } label: {
//                    Text("_size_", bundle: settings.bundle)
//                }
//            } label: {
//                Image(systemName: "textformat")
//            }
//            
//            
//            ColorPicker("", selection: $colorManager.backgroundColor)
//            ColorPicker("", selection: $colorManager.textColor)
//        }
//    }
