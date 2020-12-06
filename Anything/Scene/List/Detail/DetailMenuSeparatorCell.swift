//
//  DetailMenuSeparatorCell.swift
//  Anything
//
//  Created by Soso on 2020/12/06.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit

class DetailMenuSeparatorCell: BaseTableViewCell {
    override func layout(parent: UIView) {
        layoutContent(parent: parent)
    }
}

extension DetailMenuSeparatorCell {
    private func layoutContent(parent: UIView) {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        UIView().then { v in
            v.backgroundColor = .clear
        }.layout(parent) { m in
            m.edges.equalToSuperview()
            m.height.equalTo(12)
        }
    }
}
