//
//  Haptic.swift
//  SolveIT
//
//  Created by SOLVEIT on 28.11.20.
//  Copyright © 2020 SolveIT. All rights reserved.
//

import UIKit

/// Wrapper around UISelectionFeedbackGenerator & UINotificationFeedbackGenerator
/// - How to use:
/// ```
/// let event = HapticEvent.selection
/// event.occured()
/// ```
public enum HapticEvent {
    case selection
    case error
    case success
    case warning

    public func occured() {
        switch self {
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        case .error:
            notificationOccured(.error)
        case .success:
            notificationOccured(.success)
        case .warning:
            notificationOccured(.warning)
        }
    }
    
    private func notificationOccured(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
