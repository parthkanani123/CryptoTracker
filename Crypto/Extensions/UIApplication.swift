//
//  UIApplication.swift
//  Crypto
//
//  Created by parth kanani on 08/07/24.
//

import Foundation
import SwiftUI

extension UIApplication
{
    // this function dismissing the keyboard
    func endEditing()
    {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
