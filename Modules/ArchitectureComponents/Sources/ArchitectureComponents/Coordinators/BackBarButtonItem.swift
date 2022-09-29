//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import UIKit

// swiftlint:disable unused_setter_value

/// Custom UIBarButtonItem that removes UIBarButtonItem history menu for iOS 14+
public final class BackBarButtonItem: UIBarButtonItem {
    @available(iOS 14.0, *)
    public override var menu: UIMenu? {
        get {
            return super.menu
        }
        set { }
    }
}
// swiftlint:enabled unused_setter_value
