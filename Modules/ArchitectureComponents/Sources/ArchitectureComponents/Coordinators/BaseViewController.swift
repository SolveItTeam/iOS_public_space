import UIKit

/// Base UIViewController that handle event when screen moving from parent
open class BaseViewController: UIViewController {
    /// Callback for `isMovingFromParent` event
    public var onMovingFromParent: (() -> Void)?
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent {
            onMovingFromParent?()
        }
    }
}
