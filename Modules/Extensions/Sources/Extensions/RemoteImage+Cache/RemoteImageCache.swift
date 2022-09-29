//
//  RemoteImageCache.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import Foundation
import Kingfisher

/// An object that provides an access to remote image cache
public struct RemoteImageCache {
    private init(){}
    
    /// Clear memory and disk cache
    public static func clear() {
        let cache = KingfisherManager.shared.cache
        cache.clearCache()
        cache.clearDiskCache()
        cache.clearMemoryCache()
    }
}
