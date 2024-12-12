//
//  CircleButtonView.swift
//  MyCrypto
//
//  Created by Marco on 2024-10-29.
//

import SwiftUI

struct CircleButtonView: View {
    
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundStyle(Color.theme.accent)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundColor(Color.theme.background)
            )
            .shadow(
                color: Color.theme.accent.opacity(0.25),
                radius: 10)
            .padding()
    }
}

#Preview (traits: .sizeThatFitsLayout) {
    CircleButtonView(iconName: "info")
            .preferredColorScheme(.light)
}

#Preview (traits: .sizeThatFitsLayout) {
    CircleButtonView(iconName: "plus")
            .preferredColorScheme(.dark)
}
