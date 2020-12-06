//
//  DetailReviewHeaderCell.swift
//  Anything
//
//  Created by Soso on 2020/12/06.
//  Copyright © 2020 Soso. All rights reserved.
//

import Cosmos
import UIKit

class DetailReviewHeaderCell: BaseTableViewCell {
    var labelCount: UILabel!

    override func layout(parent: UIView) {
        layoutContent(parent: parent)
    }
}

extension DetailReviewHeaderCell {
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
            m.bottom.equalToSuperview()
        }

        UIView().then { v in
            v.backgroundColor = .rgbF1F1F1
        }.layout(parent) { m in
            m.left.right.equalToSuperview()
            m.bottom.equalToSuperview()
            m.height.equalTo(1)
        }

        layoutContainer(parent: viewContent)
    }

    private func layoutContainer(parent: UIView) {
        let labelTitle = UILabel().then { v in
            v.text = "블로그 리뷰 "
            v.textColor = .rgb3C3C3C
            v.font = .subtitle3
        }.layout(parent) { m in
            m.top.equalToSuperview().inset(13)
            m.left.equalToSuperview().inset(20)
            m.bottom.equalToSuperview().inset(15)
        }
        labelCount = UILabel().then { v in
            v.textColor = .rgb8C8C8C
            v.font = .subtitle3
        }.layout(parent) { m in
            m.top.equalToSuperview().inset(13)
            m.left.equalTo(labelTitle.snp.right)
            m.bottom.equalToSuperview().inset(15)
        }
    }
}
