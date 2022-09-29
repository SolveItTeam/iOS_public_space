//
//  RemoteImage.swift
//  
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import UIKit

/// Interface for placeholder image.
/// Should define enum **ImagePlaceholder** with all cases and conform RemoteImagePlaceholder
public protocol RemoteImagePlaceholder {
    var image: UIImage { get }
}

///  An object that represents image that should load from remote resource
public struct RemoteImage {
    let url: URL?
    let placeholder: RemoteImagePlaceholder
    
    public init(
        path: String?,
        placeholder: RemoteImagePlaceholder
    ) {
        if let imagePath = path {
            url = .init(string: imagePath)
        } else {
            url = nil
        }
        self.placeholder = placeholder
    }
}
