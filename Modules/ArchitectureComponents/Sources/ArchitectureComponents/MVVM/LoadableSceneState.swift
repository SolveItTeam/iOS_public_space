//
//  LoadableSceneState.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import Foundation

///An object that represents all basic states for sepearate application scene (single screen of the app)
enum LoadableSceneState<T: Hashable> {
    /// Indicates loading state. For this case we can show loading animation in a UIViewController
    case loading
    /// Indicates content state for a cell/view. Scene content should conform *Hashable*
    case content(data: T)
    /// Indicates error state for a scene
    case error(error: Error)
}
