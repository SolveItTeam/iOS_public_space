//
//  KeyboardEventsTracker.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import UIKit

/// Contains information about keyboard presentation notifications:
/// - UIApplication.keyboardWillShowNotification
/// - UIApplication.keyboardWillHideNotification
public struct KeyboardEventInfo {
    enum Kind {
        case willShow
        case willHide
    }
    let kind: Kind
    let animationDuration: TimeInterval
    let animationCurve: UIView.AnimationCurve
    let keyboardHeight: CGFloat
}

public extension UIViewController {
    typealias KeyboardEventAnimationBody = (_ keyboardHeight: CGFloat) -> Void
    
    @discardableResult
    /// Convenience method to perform animation when show/hide keyboard
    /// - Parameters:
    ///   - event: object from SystemEventsHandler.keyboardEventPublisher
    ///   - animated: flag that indicates should use animation duration from system notification or not
    ///   - willShowAnimationBody: animation for UIApplication.keyboardWillShowNotification
    ///   - willHideAnimationBody: animation for UIApplication.keyboardWillHideNotification
    /// - Returns: UIViewPropertyAnimator
    func animateKeyboardEvent(
        _ event: KeyboardEventInfo,
        animated: Bool = true,
        willShowAnimationBody: @escaping KeyboardEventAnimationBody,
        willHideAnimationBody: @escaping KeyboardEventAnimationBody
    ) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(
            duration: animated ? event.animationDuration : 0,
            curve: event.animationCurve
        ) {
            switch event.kind {
            case .willShow:
                willShowAnimationBody(event.keyboardHeight)
            case .willHide:
                willHideAnimationBody(event.keyboardHeight)
            }
            
            self.view?.layoutIfNeeded()
        }
        animator.startAnimation()
        return animator
    }
}

