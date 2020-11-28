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

class CategoryViewController: BaseViewController, View {
    typealias ViewModelType = CategoryViewModel

    private var tableViewCategory: UITableView!
    private var buttonCancel: UILabel!
    private var buttonSave: UILabel!

    override func layout(parent: UIView) {
        layoutContent(parent: parent)
    }

    func bind(viewModel: ViewModelType) {
        bindCategory(viewModel: viewModel)
        bindButton(viewModel: viewModel)
        bindPresentable(viewModel: viewModel)
    }
}

extension CategoryViewController {
    func bindCategory(viewModel: ViewModelType) {
        viewModel.categoryList
            .bind(to: tableViewCategory.rx.items(cellType: CategoryOptionCell.self)) { _, category, cell in
                cell.imageViewCategory.image = category.iconSmall
                cell.labelCategory.text = category.name
                cell.whenTapped()
                    .map { _ in .toggleCategory(category) }
                    .bind(to: viewModel.actions)
                    .disposed(by: cell.disposeBag)
                viewModel.selectedList
                    .map { $0.contains(category) }
                    .distinctUntilChanged()
                    .subscribe(onNext: { isSelected in
                        cell.setSelected(isSelected: isSelected)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }

    func bindButton(viewModel: ViewModelType) {
        buttonCancel.whenTapped()
            .map { _ in .cancel }
            .bind(to: viewModel.actions)
            .disposed(by: disposeBag)
        buttonSave.whenTapped()
            .map { _ in .save }
            .bind(to: viewModel.actions)
            .disposed(by: disposeBag)
    }
}

extension CategoryViewController {
    private func layoutContent(parent: UIView) {
        view.backgroundColor = .clear

        let viewTitle = UIView().layout(parent) { m in
            m.top.left.right.equalToSuperview()
            m.height.equalToSuperview().multipliedBy(0.15)
        }
        UIView().then { v in
            let labelTitle = UILabel().then { v in
                v.text = "오늘 뭐먹지?"
                v.font = UIFont.sdgothicneo(size: 30, weight: .heavy)
                v.textColor = .white
            }.layout(v) { m in
                m.top.equalToSuperview().inset(3)
                m.bottom.equalToSuperview()
                m.left.equalToSuperview()
            }
            UIImageView(image: #imageLiteral(resourceName: "btn_edit")).then { v in
                v.contentMode = .scaleAspectFit
            }.layout(v) { m in
                m.top.right.bottom.equalToSuperview()
                m.left.equalTo(labelTitle.snp.right).offset(10)
                m.width.height.equalTo(40)
            }
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
            v.font = .subtitle3
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
            v.font = .subtitle3
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
