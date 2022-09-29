//
//  NotificationCenter+Extensions.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import UIKit
import Combine

public typealias KeyboardEventPublisher = AnyPublisher<KeyboardEventInfo, Never>
public typealias SceneLifecyclePublisher = AnyPublisher<SceneLifecycleEvent, Never>

/// Application scene lifecycle events
public enum SceneLifecycleEvent {
    case willEnterForeground
    case didEnterBackground
}

public extension NotificationCenter {
    /// Publisher for UIScene.willEnterForegroundNotification **UIScene.willEnterForegroundNotification** & **UIScene.didEnterBackgroundNotification** notifications
    var sceneLifecycleEventPublisher: SceneLifecyclePublisher {
        let willEnterForeground = publisher(for: UIScene.willEnterForegroundNotification).map({ _ in SceneLifecycleEvent.willEnterForeground })
        let didEnterBackground = publisher(for: UIScene.didEnterBackgroundNotification).map({ _ in SceneLifecycleEvent.didEnterBackground })
        return Publishers.Merge(willEnterForeground, didEnterBackground).eraseToAnyPublisher()
    }
    
    /// Publisher for **UIApplication.keyboardWillShowNotification** & **UIApplication.keyboardWillHideNotification** notifications.
    /// Maps notification userInfo dictionary to KeyboardEventInfo struct with keyboard state values
    var keyboardEventPublisher: KeyboardEventPublisher {
        let show = publisher(for: UIApplication.keyboardWillShowNotification).map({ $0.keyboardEventInfo })
        let hide = publisher(for: UIApplication.keyboardWillHideNotification).map({ not -> KeyboardEventInfo in
            .init(
                kind: not.keyboardEventKind,
                animationDuration: not.keyboardAnimationDuration,
                animationCurve: not.keyboardAnimationCurve,
                keyboardHeight: .zero
            )
        })
        return Publishers.Merge(show, hide).eraseToAnyPublisher()
    }
}

private extension Notification {
    var keyboardEventKind: KeyboardEventInfo.Kind {
        name == UIApplication.keyboardWillShowNotification ? .willShow : .willHide
    }
    
    var keyboardEventInfo: KeyboardEventInfo {
        .init(
            kind: keyboardEventKind,
            animationDuration: keyboardAnimationDuration,
            animationCurve: keyboardAnimationCurve,
            keyboardHeight: keyboardEndFrame.height
        )
    }
    
    var keyboardEndFrame: CGRect {
        guard let frame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return .zero
        }
        return frame.cgRectValue
    }
    
    var keyboardAnimationDuration: TimeInterval {
        guard let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return .zero
        }
        return duration.doubleValue
    }
    
    var keyboardAnimationCurve: UIView.AnimationCurve {
        guard let curveValue = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else {
            return .easeInOut
        }
        return .init(rawValue: curveValue) ?? .easeInOut
    }
}
