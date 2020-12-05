//
//  DetailMenuHeaderCell.swift
//  Anything
//
//  Created by Soso on 2020/12/06.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit

class DetailMenuHeaderCell: BaseTableViewCell {
    var labelAll: UILabel!

    override func layout(parent: UIView) {
        layoutContent(parent: parent)
    }
}

extension DetailMenuHeaderCell {
    private func layoutContent(parent: UIView) {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        UIView().then { v in
            v.backgroundColor = .rgbF1F1F1
        }.layout(parent) { m in
            m.top.equalToSuperview()
            m.left.right.equalToSuperview()
            m.height.equalTo(6)
        }

        let viewContent = UIView().then { v in
            v.backgroundColor = .clear
        }.layout(parent) { m in
            m.top.equalToSuperview().inset(6)
            m.left.right.equalToSuperview()
            m.bottom.equalToSuperview().inset(12)
        }

        UIView().then { v in
            v.backgroundColor = .rgbF1F1F1
        }.layout(parent) { m in
            m.left.right.equalToSuperview()
            m.bottom.equalToSuperview().inset(12)
            m.height.equalTo(1)
        }

        layoutContainer(parent: viewContent)
    }

    private func layoutContainer(parent: UIView) {
        let labelTitle = UILabel().then { v in
            v.text = "메뉴"
            v.textColor = .rgb3C3C3C
            v.font = .subtitle3
        }.layout(parent) { m in
            m.top.equalToSuperview().inset(13)
            m.left.equalToSuperview().inset(20)
            m.bottom.equalToSuperview().inset(15)
        }
        labelAll = UILabel().then { v in
            v.text = "사진으로 보기"
            v.textColor = .rgb8C8C8C
            v.font = .body1
        }.layout(parent) { m in
            m.centerY.equalTo(labelTitle)
        }
        UIImageView(image: #imageLiteral(resourceName: "ic_arrow_right_16")).then { v in
            v.contentMode = .center
        }.layout(parent) { m in
            m.right.equalToSuperview().inset(20)
            m.left.equalTo(labelAll.snp.right).offset(-2)
            m.centerY.equalToSuperview()
            m.width.height.equalTo(16)
        }
    }
}
