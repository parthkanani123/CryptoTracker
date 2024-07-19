//
//  Color.swift
//  Crypto
//
//  Created by parth kanani on 04/07/24.
//

import Foundation
import SwiftUI

extension Color {
    
    static let theme = ColorTheme()
    static let launch = LaunchTheme()
}

struct ColorTheme {
    
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor1")
    let red = Color("RedColor1")
    let secondaryText = Color("SecondaryTextColor")
}

struct LaunchTheme
{
    let accent = Color("LaunchAccentColor")
    let background = Color("LaunchBackgroundColor")
}
