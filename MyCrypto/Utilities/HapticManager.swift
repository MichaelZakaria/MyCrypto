//
//  HapticManager.swift
//  MyCrypto
//
//  Created by Micheal on 08/12/2024.
//

import SwiftUI

class HapticManager {
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
