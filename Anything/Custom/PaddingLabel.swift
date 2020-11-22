//
//  PaddingLabel.swift
//  d.code
//
//  Created by Soso on 2020/10/22.
//  Copyright © 2020 n.code. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {
    var edgeInsets: UIEdgeInsets = .zero

    override var intrinsicContentSize: CGSize {
        let inset = edgeInsets
        let size = super.intrinsicContentSize
        return CGSize(width: inset.left + size.width + inset.right,
                      height: inset.top + size.height + inset.bottom)
    }
}
