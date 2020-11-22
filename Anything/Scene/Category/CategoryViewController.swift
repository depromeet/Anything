//
//  CategoryViewController.swift
//  Anything
//
//  Created by Soso on 2020/11/22.
//  Copyright © 2020 Soso. All rights reserved.
//

import Reusable
import RxSwift
import UIKit

class CategoryViewController: BaseViewController {
    private var tableViewCategory: UITableView!
    private var buttonCancel: UILabel!
    private var buttonSave: UILabel!

    override func layout(parent: UIView) {
        layoutContent(parent: parent)
    }
}

extension CategoryViewController {
    private func layoutContent(parent: UIView) {
        view.backgroundColor = .clear

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

        tableViewCategory = ResizableTableView().then { v in
            v.register(cellType: CategoryOptionCell.self)
            v.separatorStyle = .none
            v.backgroundColor = .clear
            v.rowHeight = 48
            v.isScrollEnabled = false
        }.layout(parent) { m in
            m.top.equalTo(viewTitle.snp.bottom).offset(10)
            m.left.right.equalToSuperview()
        }

        let viewBottom = UIView().then { v in
            v.backgroundColor = 0x141414.color
        }.layout(parent) { m in
            m.top.equalTo(tableViewCategory.snp.bottom).offset(50)
            m.left.right.equalToSuperview()
            m.bottom.equalTo(parent.safeAreaLayoutGuide)
        }
        layoutBottom(parent: viewBottom)
    }

    private func layoutBottom(parent: UIView) {
        buttonCancel = UILabel().then { v in
            v.text = "취소"
            v.textColor = .white
            v.textAlignment = .center
            v.backgroundColor = .clear
            v.layer.cornerRadius = 8
            v.layer.masksToBounds = true
            v.layer.borderColor = UIColor.rgbDCDCDC.cgColor
            v.layer.borderWidth = 1
        }
        buttonSave = UILabel().then { v in
            v.text = "저장"
            v.textColor = .white
            v.textAlignment = .center
            v.backgroundColor = .rgbFD4145
            v.layer.cornerRadius = 8
            v.layer.masksToBounds = true
        }
        UIStackView(
            arrangedSubviews: [buttonCancel, buttonSave]
        ).then { v in
            v.axis = .horizontal
            v.distribution = .fillEqually
            v.alignment = .fill
            v.spacing = 10
        }.layout(parent) { m in
            m.top.equalToSuperview().inset(36)
            m.left.right.equalToSuperview().inset(20)
            m.height.equalTo(48)
        }
    }
}
