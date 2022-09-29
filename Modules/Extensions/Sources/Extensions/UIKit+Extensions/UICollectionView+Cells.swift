//
//  UICollectionView+Extension.swift
//
//  Created by SOLVEIT on 16.11.20.
//  Copyright © 2020 SOLVEIT. All rights reserved.

import UIKit

// swiftlint:disable force_cast
public extension UICollectionView {
    /// Allows to register a UICollectionReusableView that loads from a Xib file
    func register<ReusableView: NibCollectionReusableView>(nibView: ReusableView.Type) {
        register(
            nibView.nib,
            forSupplementaryViewOfKind: nibView.kind,
            withReuseIdentifier: nibView.identifier
        )
    }
    
    /// Allows to register a UICollectionViewCell that loads from a Xib file
    func register<Cell: CollectionViewNibCell>(nibCell: Cell.Type) {
        register(nibCell.nib, forCellWithReuseIdentifier: nibCell.identifier)
    }
    
    func dequeueNibCell<Cell: CollectionViewNibCell>(
        type: Cell.Type,
        for path: IndexPath
    ) -> Cell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: path) as! Cell
        return cell
    }
    
    /// Allows to dequeue a UICollectionReusableView that loads from Xib file
    func dequeueSupplimentaryNib<ReusableView: NibCollectionReusableView>(
        type: ReusableView.Type,
        for path: IndexPath
    ) -> ReusableView {
        let view = dequeueReusableSupplementaryView(
            ofKind: ReusableView.kind,
            withReuseIdentifier: ReusableView.identifier,
            for: path
        ) as! ReusableView
        return view
    }
}
// swiftlint:enable force_cast

