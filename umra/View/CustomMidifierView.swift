//
//  CustomMidifier.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

//MARK: ImageCustomMidifier



extension Image {
    func customImageStyle() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(.bottom)
            .clipShape(Circle())
            .padding(.all, 24)
            .background(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)))
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .shadow(color: Color.black.opacity(0.35), radius: 8, x: 8, y: 8)
            .padding(25)
    }
}

struct ImageCustomModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 10, y: 10)
            .padding(25)
    }
}

extension View {
    func imageCustomModifier() -> some View {
        self.modifier(ImageCustomModifier())
    }
}

//MARK: TextCustomMidifier

struct CustomText: View {
    var name: String
    var body: some View {
      Text(name)
            .font(.custom("Lato-Black", size: 38))
            .foregroundColor(Color.init(#colorLiteral(red: 0.5188618898, green: 0.2738361061, blue: 0.2221542895, alpha: 1)))
            .multilineTextAlignment(.center)
            .padding(10)

    }
}
//MARK: CustomTextforSteps

struct CustomTextforSteps: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.custom("Lato-Black", size: 38))
            .frame(maxWidth: .infinity)
            .background(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.black.opacity(0.35), radius: 8, x: 8, y: 8)
            .padding(.horizontal, 10)
    }
}

extension View {
    func customTextforArabic() -> some View {
        self.modifier(CustomTextforSteps())
    }
}


struct TitleTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Lato-Black", size: 38))
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .padding(10)
    }
}

extension View {
    func titleTextModifier() -> some View {
        self.modifier(TitleTextModifier())
    }
}
