//
//  ResizableTableView.swift
//  d.code
//
//  Created by Soso on 2020/10/15.
//  Copyright © 2020 n.code. All rights reserved.
//

import UIKit

class ResizableTableView: UITableView {
    var maxHeight: CGFloat = 0

    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        var height: CGFloat
        if maxHeight != 0 {
            height = min(contentSize.height, maxHeight)
        } else {
            height = contentSize.height
        }
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        invalidateIntrinsicContentSize()
    }
}
