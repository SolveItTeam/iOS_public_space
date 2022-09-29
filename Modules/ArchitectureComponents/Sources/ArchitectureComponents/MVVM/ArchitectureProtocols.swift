//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import UIKit

/// List of all shared protocols for MVVM architecture
/// MVVM + Clea architecture:
/// - [OLX Group Engineering blog](https://tech.olx.com/clean-architecture-and-mvvm-on-ios-c9d167d9f5b3#:~:text=The%20Model%2DView%2DViewModel%20pattern,used%20with%20the%20same%20ViewModel.)

/// Protocol for connect UIViewController lifecycle with ViewModel. All ViewModelInput protocols should inherits from this
/// **Example**:
/// **Task**: We need to setup default state for module view, module state stores in ViewModel. How to solve this?
/// **Solution**: Our ViewModelInput has `viewDidLoad` method (because it inherits from SceneViewLifecycleEvents) with default empty implementation.
/// Inside ViewModel you need to implement `viewDidLoad` method and in UIViewController inside `viewDidLoad` write `viewModel.viewDidLoad()`
public protocol SceneViewLifecycleEvents {
    /// To connect `UIViewController.viewDidLoad`
    func viewDidLoad()
    /// To connect `UIViewController.viewWillAppear`
    func viewWillAppear()
    /// To connect `UIViewController.viewDidAppear`
    func viewDidAppear()
    /// To connect `UIViewController.viewWillDisappear`
    func viewWillDisappear()
}

public extension SceneViewLifecycleEvents {
    func viewDidLoad() {}
    func viewWillAppear() {}
    func viewDidAppear() {}
    func viewWillDisappear() {}
}
