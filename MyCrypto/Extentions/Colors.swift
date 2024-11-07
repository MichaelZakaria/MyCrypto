//
//  Colors.swift
//  MyCrypto
//
//  Created by Marco on 2024-10-29.
//

import Foundation
import SwiftUI

extension Color{
    
    static let theme = ColorTheme()
    
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
}

