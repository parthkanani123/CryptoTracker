//
//  HapticManager.swift
//  Crypto
//
//  Created by parth kanani on 13/07/24.
//

import Foundation
import SwiftUI

class HapticManager
{
    static let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType)
    {
        generator.notificationOccurred(type)
    }
}
