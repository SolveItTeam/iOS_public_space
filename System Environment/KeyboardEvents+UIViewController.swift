//
//  KeyboardEventsTracker.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import UIKit

struct KeyboardEventInfo {
    enum Kind {
        case willShow
        case willHide
    }
    let kind: Kind
    let animationDuration: TimeInterval
    let animationCurve: UIView.AnimationCurve
    let keyboardHeight: CGFloat
}

extension UIViewController {
    @discardableResult
    func animateKeyboardEvent(
        _ event: KeyboardEventInfo,
        animated: Bool = true,
        animationBody: @escaping (_ keyboardHeight: CGFloat) -> Void
    ) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(
            duration: animated ? event.animationDuration : 0,
            curve: event.animationCurve
        ) {
            animationBody(event.keyboardHeight)
            self.view?.layoutIfNeeded()
        }
        animator.startAnimation()
        return animator
    }
}
