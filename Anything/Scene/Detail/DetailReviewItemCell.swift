//
//  DetailReviewItemCell.swift
//  Anything
//
//  Created by Soso on 2020/12/06.
//  Copyright © 2020 Soso. All rights reserved.
//

import Cosmos
import UIKit
import Kingfisher

class DetailReviewItemCell: BaseTableViewCell {
    var labelTitle: UILabel!
    var imageView1: UIImageView!
    var imageView2: UIImageView!
    var imageView3: UIImageView!
    var labelContent: UILabel!
    var labelName: UILabel!
    var labelDate: UILabel!

    override func layout(parent: UIView) {
        layoutContent(parent: parent)
    }
}

extension DetailReviewItemCell {
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
        labelTitle = UILabel().then { v in
            v.textColor = .rgb646464
            v.font = .body2
        }.layout(parent) { m in
            m.top.equalToSuperview().inset(16)
            m.left.equalToSuperview().inset(20)
        }

        let stackViewImage = UIStackView().then { v in
            v.axis = .horizontal
            v.alignment = .fill
            v.distribution = .fillEqually
            v.spacing = 3
        }.layout(parent) { m in
            m.top.equalTo(labelTitle.snp.bottom).offset(10)
            m.left.right.equalToSuperview().inset(20)
            m.height.equalTo(92)
        }
        imageView1 = AnimatedImageView().then { v in
            v.contentMode = .scaleAspectFill
            v.backgroundColor = .rgbDCDCDC
            v.clipsToBounds = true
        }.layout(stackViewImage)
        imageView2 = AnimatedImageView().then { v in
            v.contentMode = .scaleAspectFill
            v.backgroundColor = .rgbDCDCDC
            v.clipsToBounds = true
        }.layout(stackViewImage)
        imageView3 = AnimatedImageView().then { v in
            v.contentMode = .scaleAspectFill
            v.backgroundColor = .rgbDCDCDC
            v.clipsToBounds = true
        }.layout(stackViewImage)

        labelContent = UILabel().then { v in
            v.textColor = .rgb646464
            v.font = .body1
            v.numberOfLines = 3
        }.layout(parent) { m in
            m.top.equalTo(stackViewImage.snp.bottom).offset(8)
            m.left.right.equalTo(stackViewImage)
        }

        let viewInfo = UIView().then { v in
            v.backgroundColor = .red
        }.layout(parent) { m in
            m.top.equalTo(labelContent.snp.bottom).offset(6)
            m.left.equalTo(labelContent)
            m.bottom.equalToSuperview().inset(16)
        }
        layoutInfo(parent: viewInfo)
    }

    private func layoutInfo(parent: UIView) {
        labelName = UILabel().then { v in
            v.textColor = .rgb8C8C8C
            v.font = .caption1
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
