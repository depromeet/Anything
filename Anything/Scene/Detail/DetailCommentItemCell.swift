//
//  DetailCommentItemCell.swift
//  Anything
//
//  Created by Soso on 2020/12/06.
//  Copyright © 2020 Soso. All rights reserved.
//

import Cosmos
import UIKit

class DetailCommentItemCell: BaseTableViewCell {
    var imageViewProfile: UIImageView!
    var viewRating: CosmosView!
    var labelName: UILabel!
    var labelDate: UILabel!
    var labelContent: UILabel!

    override func layout(parent: UIView) {
        layoutContent(parent: parent)
    }
}

extension DetailCommentItemCell {
    private func layoutContent(parent: UIView) {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        let viewContent = UIView().then { v in
            v.backgroundColor = .clear
        }.layout(parent) { m in
            m.edges.equalToSuperview()
        }

        layoutContainer(parent: viewContent)

        UIView().then { v in
            v.backgroundColor = .rgbF1F1F1
        }.layout(parent) { m in
            m.left.right.equalToSuperview()
            m.bottom.equalToSuperview()
            m.height.equalTo(1)
        }
    }

    private func layoutContainer(parent: UIView) {
        imageViewProfile = UIImageView().then { v in
            v.backgroundColor = .rgbDCDCDC
            v.layer.cornerRadius = 8
            v.layer.masksToBounds = true
        }.layout(parent) { m in
            m.top.equalToSuperview().inset(16)
            m.left.equalToSuperview().inset(20)
            m.width.height.equalTo(30)
        }

        viewRating = CosmosView().then { v in
            v.rating = 4
            v.settings.fillMode = .precise
            v.settings.emptyImage = #imageLiteral(resourceName: "ic_star_normal_12pt")
            v.settings.filledImage = #imageLiteral(resourceName: "ic_star_fill_12pt")
            v.settings.starSize = 12
            v.settings.starMargin = 1
            v.settings.updateOnTouch = false
        }.layout(parent) { m in
            m.top.equalTo(imageViewProfile)
            m.left.equalTo(imageViewProfile.snp.right).offset(10)
        }

        let viewInfo = UIView().then { v in
            v.backgroundColor = .red
        }.layout(parent) { m in
            m.top.equalTo(viewRating.snp.bottom).offset(3)
            m.left.equalTo(viewRating)
        }
        layoutInfo(parent: viewInfo)

        labelContent = UILabel().then { v in
            v.textColor = .rgb646464
            v.font = .body1
            v.numberOfLines = 4
        }.layout(parent) { m in
            m.top.equalTo(viewInfo.snp.bottom).offset(7)
            m.left.equalTo(viewInfo)
            m.right.equalToSuperview().inset(20)
            m.bottom.equalToSuperview().inset(16)
        }
    }

    private func layoutInfo(parent: UIView) {
        labelName = UILabel().then { v in
            v.textColor = .rgb646464
            v.font = .caption2
        }.layout(parent) { m in
            m.top.left.bottom.equalToSuperview()
        }
        labelDate = UILabel().then { v in
            v.textColor = .rgb8C8C8C
            v.font = .caption1
        }.layout(parent) { m in
            m.top.bottom.equalToSuperview()
            m.left.equalTo(labelName.snp.right).offset(13)
        }
        UIView().then { v in
            v.backgroundColor = .rgbDCDCDC
        }.layout(parent) { m in
            m.top.bottom.equalToSuperview().inset(3)
            m.left.equalTo(labelName.snp.right).offset(6)
            m.width.equalTo(1)
        }
    }
}
