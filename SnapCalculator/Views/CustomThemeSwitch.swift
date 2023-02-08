//
//  CustomThemeSwitch.swift
//  SnapCalculator
//
//  Created by Widya Limarto on 08/02/23.
//

import SwiftUI

struct CustomThemeSwitch: View {
    
    @AppStorage("theme") var theme : String = "green"
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 3)) {
                if theme == "green" {
                    theme = "red"
                } else {
                    theme = "green"
                }
            }
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(Color.atlasWhite)
                    .padding(0)
                    .frame(width: 20, height: 20)
            }
            .frame(width: 50, height: 25, alignment: theme == "green" ? .leading : .trailing)
            .padding(.horizontal, 2)
            .background(theme == "green" ? Color.darkRose : Color.herbal)
            .cornerRadius(50)
        }
    }
}

struct CustomThemeSwitch_Previews: PreviewProvider {
    static var previews: some View {
        CustomThemeSwitch()
    }
}
