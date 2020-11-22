//
//  CategoryOptionCell.swift
//  Anything
//
//  Created by Soso on 2020/11/22.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit

class CategoryOptionCell: BaseTableViewCell {
    var imageViewCheck: UIImageView!
    var imageViewCategory: UIImageView!
    var labelCategory: UILabel!

    override func layout(parent: UIView) {
        layoutContent(parent: parent)
    }

    func setSelected(isSelected: Bool) {
        if isSelected {
            imageViewCheck.image = #imageLiteral(resourceName: "check_selected")
        } else {
            imageViewCheck.image = #imageLiteral(resourceName: "check_disabled")
        }
    }
}

extension CategoryOptionCell {
    private func layoutContent(parent: UIView) {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        let viewContent = UIView().then { v in
            v.backgroundColor = .white
            v.layer.cornerRadius = 8
            v.layer.masksToBounds = true
        }.layout(parent) { m in
            m.top.bottom.equalToSuperview().inset(4)
            m.left.right.equalToSuperview().inset(20)
        }

        layoutItems(parent: viewContent)
    }

    private func layoutItems(parent: UIView) {
        imageViewCheck = UIImageView(image: #imageLiteral(resourceName: "check_disabled")).layout(parent) { m in
            m.left.equalToSuperview().inset(16)
            m.centerY.equalToSuperview()
            m.width.height.equalTo(20)
        }
        imageViewCategory = UIImageView().layout(parent) { m in
            m.left.equalTo(imageViewCheck.snp.right).offset(12)
            m.centerY.equalToSuperview()
            m.width.equalTo(30)
            m.height.equalTo(26)
        }
        labelCategory = UILabel().then { v in
            v.textColor = .rgb3C3C3C
            v.font = .sdgothicneo(size: 17, weight: .bold)
        }.layout(parent) { m in
            m.left.equalTo(imageViewCategory.snp.right).offset(12)
            m.centerY.equalToSuperview()
        }
    }
}
