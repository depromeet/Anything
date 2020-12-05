//
//  DetailMenuItemCell.swift
//  Anything
//
//  Created by Soso on 2020/12/06.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit

class DetailMenuItemCell: BaseTableViewCell {
    var labelName: UILabel!
    var labelPrice: UILabel!

    override func layout(parent: UIView) {
        layoutContent(parent: parent)
    }
}

extension DetailMenuItemCell {
    private func layoutContent(parent: UIView) {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        let viewContent = UIView().then { v in
            v.backgroundColor = .clear
        }.layout(parent) { m in
            m.edges.equalToSuperview()
            m.height.equalTo(28)
        }

        layoutContainer(parent: viewContent)
    }

    private func layoutContainer(parent: UIView) {
        labelName = UILabel().then { v in
            v.textColor = .rgb646464
            v.font = .body1
        }.layout(parent) { m in
            m.left.equalToSuperview().inset(20)
            m.centerY.equalToSuperview()
        }
        labelPrice = UILabel().then { v in
            v.textColor = .rgb646464
            v.font = .body1
        }.layout(parent) { m in
            m.right.equalToSuperview().inset(20)
            m.centerY.equalToSuperview()
        }

        UIView().then { v in
            v.backgroundColor = .rgbF1F1F1
        }.layout(parent) { m in
            m.left.equalTo(labelName.snp.right).offset(4)
            m.right.equalTo(labelPrice.snp.left).offset(-4)
            m.centerY.equalToSuperview()
            m.height.equalTo(1)
        }
    }
}
