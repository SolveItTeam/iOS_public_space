//
//  UIView+Geometry.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SOLVEIT. All rights reserved.

import UIKit

public extension UIView {
    /// Returns __frame.origin.x__
    var x: CGFloat {
        get { return frame.origin.x }
        set { frame.origin.x = newValue }
    }
    
    /// Returns __frame.origin.y__
    var y: CGFloat {
        get { return frame.origin.y }
        set { frame.origin.y = newValue }
    }
    
    /// Returns __frame.origin__
    var origin: CGPoint {
        get { return frame.origin }
        set { frame.origin = newValue }
    }
    
    //MARK: - Sides
    /// Returns coordinate of a left side
    var left: CGFloat {
        get { return x }
        set {
            width += x - newValue
            x = newValue
        }
    }
    
    /// Returns coordinate of a top side
    var top: CGFloat {
        get { return y }
        set {
            height += y - newValue
            y = newValue
        }
    }
    
    /// Returns coordinate of a right side
    var right: CGFloat {
        get { return x + width }
        set { x = newValue - width }
    }
    
    /// Returns coordinate of a bottom side
    var bottom: CGFloat {
        get { return y + height }
        set { y = newValue - height }
    }
    
    //MARK: - Corners
    var topLeft: CGPoint {
        get { return origin }
        set { left = newValue.x; top = newValue.y }
    }
    
    var topRight: CGPoint {
        get { return CGPoint(x: right, y: top) }
        set { right = newValue.x; top = newValue.y }
    }
    
    var bottomRight: CGPoint {
        get { return CGPoint(x: right, y: bottom) }
        set { right = newValue.x; bottom = newValue.y }
    }
    
    var bottomLeft: CGPoint {
        get { return CGPoint(x: left, y: bottom) }
        set { left = newValue.x; bottom = newValue.y }
    }
    
    //MARK: - Center
    var centerX: CGFloat {
        get { return self.center.x }
        set { self.x = newValue - self.width/2 }
    }
    
    var centerY: CGFloat {
        get { return self.center.y }
        set { self.y = newValue - self.height/2 }
    }
    
    //MARK: - Size
    
    /// Returns __bounds.size.width __
    var width: CGFloat {
        get { return bounds.size.width }
        set {
            var bounds = self.bounds
            bounds.size.width = newValue
            self.bounds = bounds
        }
    }
    
    /// Returns __bounds.size.height __
    var height: CGFloat {
        get { return bounds.size.height }
        set {
            var bounds = self.bounds
            bounds.size.height = newValue
            self.bounds = bounds
        }
    }
    
    /// Returns __bounds.size __
    var size: CGSize {
        get { return bounds.size }
        set {
            var bounds = self.bounds
            bounds.size = newValue
            self.bounds = bounds
        }
    }
    
    //MARK: Other
    var diagonal: CGFloat {
        return CGFloat(sqrt(width * width + height * height))
    }
}

//MARK: - UIScrollView
public extension UIScrollView {
    var contentOffsetX: CGFloat {
        get { return self.contentOffset.x }
        set { self.contentOffset = CGPoint(x: newValue, y: contentOffset.y) }
    }
    
    var contentOffsetY: CGFloat {
        get { return self.contentOffset.y }
        set {
            self.contentOffset = CGPoint(x: contentOffset.x, y: newValue)
        }
    }
    
    var scrollProgress: CGFloat {
        (contentOffsetY + frame.height) / contentSize.height
    }
}

