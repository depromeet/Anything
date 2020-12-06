//
//  DetailMenuHeaderCell.swift
//  Anything
//
//  Created by Soso on 2020/12/06.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit

class DetailMoreCell: BaseTableViewCell {
    var labelMore: UILabel!

    override func layout(parent: UIView) {
        layoutContent(parent: parent)
    }
}

extension DetailMoreCell {
    private func layoutContent(parent: UIView) {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        let viewContent = UIView().then { v in
            v.backgroundColor = .clear
        }.layout(parent) { m in
            m.edges.equalToSuperview()
            m.height.equalTo(40)
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
        labelMore = UILabel().then { v in
            v.textColor = .rgb8C8C8C
            v.font = .body1
        }.layout(parent) { m in
            m.centerY.equalToSuperview()
        }
        UIImageView(image: #imageLiteral(resourceName: "ic_arrow_right_16")).then { v in
            v.contentMode = .center
        }.layout(parent) { m in
            m.right.equalToSuperview().inset(20)
            m.left.equalTo(labelMore.snp.right).offset(-2)
            m.centerY.equalToSuperview()
            m.width.height.equalTo(16)
        }
    }
}
