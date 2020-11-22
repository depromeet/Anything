//
//  CategoryViewController.swift
//  Anything
//
//  Created by Soso on 2020/11/22.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit

class CategoryViewController: BaseViewController {
    override func layout(parent: UIView) {
        layoutContent(parent: parent)
    }
}

extension CategoryViewController {
    private func layoutContent(parent: UIView) {
        view.backgroundColor = .clear

        UIImageView(image: #imageLiteral(resourceName: "image_main_background")).layout(parent) { m in
            m.top.left.right.equalToSuperview()
        }

        let viewTitle = UIView().layout(parent) { m in
            m.top.left.right.equalToSuperview()
            m.height.equalToSuperview().multipliedBy(0.15)
        }
        UILabel().then { v in
            v.text = "돌림판 편집"
            v.font = UIFont.sdgothicneo(size: 30, weight: .heavy)
            v.textColor = .white
        }.layout(viewTitle) { m in
            m.center.equalToSuperview()
        }
    }
}
