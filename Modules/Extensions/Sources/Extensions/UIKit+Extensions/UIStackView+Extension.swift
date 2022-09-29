//
//  UIStackView+Extension.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import UIKit

/// Result builder type that allows to implement declarative style UIStackView arrangedSubviews content
@resultBuilder
struct UIStackViewContentBuilder {
    static func buildBlock(_ components: UIView...) -> [UIView] {
        components
    }
}

/// Wrapper around basic UIStackView with predefined *axis == .vertical*
/// Allows to describe stack content in declarative style
/// *Example*:
/// ```
///  let text = UILabel()
///  text.backgroundColor = .gray
///  text.text = "TEST"
///
///  let redView = UIView()
///  redView.backgroundColor = .red
///  let stack = VStackView(spacing: 5, distribution: .fillEqually) {
///    text
///    redView
///  }
/// ```
final class VStackView: ContentBuildableStackView {
    /// Initialize vertical stack view with given parameters
    /// - Parameters:
    ///   - frame: frame for a stack
    ///   - spacing: spacing between items in stack
    ///   - distribution: basic UIStackView.Distribution
    ///   - content: see UIStackViewContentBuilder
    init(
        frame: CGRect = .zero,
        spacing: CGFloat,
        distribution: UIStackView.Distribution,
        @UIStackViewContentBuilder content: @escaping () -> [UIView]
    ) {
        super.init(
            axis: .vertical,
            frame: frame,
            spacing: spacing,
            distribution: distribution,
            content: content
        )
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        axis = .vertical
    }
}

/// Wrapper around basic UIStackView with predefined *axis == .horizontal*
/// Allows to describe stack content in declarative style
/// *Example*:
/// ```
///  let text = UILabel()
///  text.backgroundColor = .gray
///  text.text = "TEST"
///
///  let redView = UIView()
///  redView.backgroundColor = .red
///  let stack = HStackView(spacing: 5, distribution: .fillEqually) {
///    text
///    redView
///  }
/// ```
final class HStackView: ContentBuildableStackView {
    /// Initialize horizontal stack view with given parameters
    /// - Parameters:
    ///   - frame: frame for a stack
    ///   - spacing: spacing between items in stack
    ///   - distribution: basic UIStackView.Distribution
    ///   - content: see UIStackViewContentBuilder
    init(
        frame: CGRect = .zero,
        spacing: CGFloat,
        distribution: UIStackView.Distribution,
        @UIStackViewContentBuilder content: @escaping () -> [UIView]
    ) {
        super.init(
            axis: .horizontal,
            frame: frame,
            spacing: spacing,
            distribution: distribution,
            content: content
        )
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        axis = .horizontal
    }
}

class ContentBuildableStackView: UIStackView {
    //MARK: - Initialization
    init(
        axis: NSLayoutConstraint.Axis,
        frame: CGRect = .zero,
        spacing: CGFloat,
        distribution: UIStackView.Distribution,
        @UIStackViewContentBuilder content: @escaping () -> [UIView]
    ) {
        super.init(frame: frame)
        self.axis = axis
        self.set(spacing: spacing)
            .set(distribution: distribution)
            .set(content: content)
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    //MARK: - Setters
    @discardableResult
    func set(spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }

    @discardableResult
    func set(distribution: UIStackView.Distribution) -> Self {
        self.distribution = distribution
        return self
    }

    @discardableResult
    func set(@UIStackViewContentBuilder content: @escaping () -> [UIView]) -> Self {
        for item in content() {
            addArrangedSubview(item)
        }
        return self
    }
}
