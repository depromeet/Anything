//
//  AddressCell.swift
//  Anything
//
//  Created by Soso on 2020/11/28.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit

class AddressCell: BaseTableViewCell {
    var labelName: UILabel!
    var labelAddress: UILabel!

    override func layout(parent: UIView) {
        layoutContent(parent: parent)
    }
}

extension AddressCell {
    private func layoutContent(parent: UIView) {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        let viewContent = UIView().then { v in
            v.backgroundColor = .clear
        }.layout(parent) { m in
            m.top.bottom.equalToSuperview()
            m.left.right.equalToSuperview()
        }

        layoutItems(parent: viewContent)
    }

    private func layoutItems(parent: UIView) {
        UIImageView(image: #imageLiteral(resourceName: "ic_pin_24")).layout(parent) { m in
            m.left.equalToSuperview().inset(20)
            m.centerY.equalToSuperview()
            m.width.height.equalTo(24)
        }
        
        UIView().then { v in
            labelName = UILabel().then { v in
                v.font = .subtitle3
                v.textColor = .rgbFFFFFF
            }.layout(v) { m in
                m.top.left.right.equalToSuperview()
            }
            labelAddress = UILabel().then { v in
                v.font = .body1
                v.textColor = .rgbDCDCDC
            }.layout(v) { m in
                m.top.equalTo(labelName.snp.bottom).offset(8)
                m.left.right.bottom.equalToSuperview()
            }
        }.layout(parent) { m in
            m.left.equalToSuperview().inset(60)
            m.right.equalToSuperview().inset(20)
            m.centerY.equalToSuperview()
        }
    }
}


