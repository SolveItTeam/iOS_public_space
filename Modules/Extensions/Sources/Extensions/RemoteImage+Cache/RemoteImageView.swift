//
//  RemoteImageView.swift
//  
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import UIKit
import Kingfisher

/// An object that displays a single image from remote resource in your interface
public final class RemoteImageView: UIImageView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public override init(image: UIImage?) {
        super.init(image: image)
    }
    
    public override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func load(_ image: RemoteImage) {
        self.image = image.placeholder.image
        if let url = image.url {
            loadContent(at: url, placeholder: image.placeholder.image)
        }
    }
}

extension UIImageView {
    func loadContent(at url: URL, placeholder: UIImage) {
        let kfResource = ImageResource(downloadURL: url)
        kf.setImage(
            with: kfResource,
            placeholder: placeholder,
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ],
            completionHandler: { [weak self] result in
                switch result {
                case .failure:
                    self?.image = placeholder
                case .success(let imageResult):
                    if imageResult.source.url?.absoluteString == url.absoluteString {
                        self?.image = imageResult.image
                    } else {
                        self?.image = placeholder
                    }
                }
        })
    }
}
