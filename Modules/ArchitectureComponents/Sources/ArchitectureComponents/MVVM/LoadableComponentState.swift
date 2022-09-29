//
//  LoadableComponentState.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import Foundation

/// Represents all basic states for sepearate UI component. Ex.: UITable/UICollectionViewCell, custom UI
enum LoadableComponentState<T: Hashable>: Hashable {
    /// Indicates loading state. For this case we can show loading animation in a cell/view
    case loading
    /// Indicates content state for a cell/view. Component content should conform *Hashable*
    case content(data: T)
}
