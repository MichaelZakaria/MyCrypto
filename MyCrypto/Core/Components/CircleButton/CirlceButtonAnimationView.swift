//
//  CirlceButtonAnimationView.swift
//  MyCrypto
//
//  Created by Marco on 2024-10-30.
//

import SwiftUI

struct CirlceButtonAnimationView: View {
    
    @Binding var animate: Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(animate ? .easeIn(duration: 1) : .none, value: animate)
            
    }
}

#Preview {
    CirlceButtonAnimationView(animate: .constant(false))
        .frame(width: 100, height: 100)
}
