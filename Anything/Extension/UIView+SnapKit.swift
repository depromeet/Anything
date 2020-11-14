//
//  UIView+SnapKit.swift
//  d.code
//
//  Created by Soso on 2020/09/08.
//  Copyright © 2020 n.code. All rights reserved.
//

import SnapKit
import Then
import UIKit

extension Then where Self: UIView {
    @discardableResult
    func layout(
        _ parent: UIView,
        index: Int? = nil,
        below: UIView? = nil,
        above: UIView? = nil,
        closure: (ConstraintMaker) -> Void = { _ in }
    ) -> Self {
        switch parent {
        case let stack as UIStackView:
            stack.addArrangedSubview(self)
        case let collectionCell as UICollectionViewCell:
            collectionCell.contentView.addSubview(self)
        case let tableCell as UITableViewCell:
            tableCell.contentView.addSubview(self)
        case let scrollView as UIScrollView:
            if let refresh = self as? UIRefreshControl {
                scrollView.refreshControl = refresh
            } else {
                scrollView.addSubview(self)
            }
        default:
            if let index = index {
                parent.insertSubview(self, at: index)
            } else if let below = below {
                parent.insertSubview(self, belowSubview: below)
            } else if let above = above {
                parent.insertSubview(self, aboveSubview: above)
            } else {
                parent.addSubview(self)
            }
        }
        snp.makeConstraints(closure)
        return self
    }
}
