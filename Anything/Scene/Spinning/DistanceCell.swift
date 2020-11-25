//
//  DistanceCell.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/16.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit

class DistanceCell: BaseTableViewCell {
    var labelDistance: UILabel!
    var labelTitle: UILabel!
    var imageViewCheck: UIImageView!

    override func layout(parent: UIView) {
        layoutContent(parent: parent)
    }

    func setSelected(isSelected: Bool) {
        if isSelected {
            labelDistance.textColor = .rgb646464
            labelDistance.backgroundColor = .white
            labelTitle.textColor = .white
            imageViewCheck.isHidden = false
        } else {
            labelDistance.textColor = .rgb8C8C8C
            labelDistance.backgroundColor = .rgb282828
            labelTitle.textColor = .rgb8C8C8C
            imageViewCheck.isHidden = true
        }
    }
}

extension DistanceCell {
    private func layoutContent(parent: UIView) {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        labelDistance = UILabel().then { v in
            v.font = UIFont.sdgothicneo(size: 12, weight: .bold)
            v.textColor = .rgb8C8C8C
            v.textAlignment = .center
            v.backgroundColor = .rgb282828
            v.layer.cornerRadius = 8
            v.layer.masksToBounds = true
        }.layout(parent) { m in
            m.top.bottom.equalToSuperview().inset(12)
            m.left.equalToSuperview().inset(20)
            m.width.equalTo(55)
        }
        labelTitle = UILabel().then { v in
            v.font = UIFont.sdgothicneo(size: 17, weight: .bold)
            v.textColor = .rgb8C8C8C
        }.layout(parent) { m in
            m.left.equalTo(labelDistance.snp.right).offset(10)
            m.right.equalToSuperview().inset(40)
            m.centerY.equalToSuperview()
        }
        imageViewCheck = UIImageView(image: #imageLiteral(resourceName: "ic_check")).then { v in
            v.isHidden = true
        }.layout(parent) { m in
            m.right.equalToSuperview().inset(20)
            m.centerY.equalToSuperview()
            m.width.height.equalTo(16)
        }
    }
}
