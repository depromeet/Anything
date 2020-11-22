//
//  SpinningViewController.swift
//  Anything
//
//  Created by Soso on 2020/11/22.
//  Copyright © 2020 Soso. All rights reserved.
//

import RxGesture
import RxSwift
import SnapKit
import SwiftyColor
import UIKit

class SpinningViewController: BaseViewController, View {
    typealias ViewModelType = SpinningViewModel

    var imageViewEdit: UIImageView!

    private var circularView: CircularView!
    private var viewAnimate: UIImageView!
    private var viewCategories: [CategoryView]!

    override func layout(parent: UIView) {
        layoutContent(parent: parent)
    }

    func bind(viewModel: ViewModelType) {
        bindSpinningWheel(viewModel: viewModel)
        bindInfo(viewModel: viewModel)
        bindPresentable(viewModel: viewModel)
    }
}

extension SpinningViewController {
    func bindSpinningWheel(viewModel: ViewModelType) {
        viewModel.isAnimating
            .bind(to: viewAnimate.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel.isAnimating
            .bind(to: viewAnimate.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel.categories
            .distinctUntilChanged()
            .bind(to: circularView.rx.categories)
            .disposed(by: disposeBag)
        viewModel.currentIndex
            .distinctUntilChanged()
            .bind(to: circularView.rx.currentIndex)
            .disposed(by: disposeBag)

        viewAnimate.whenTapped()
            .map { _ in .animate }
            .bind(to: viewModel.actions)
            .disposed(by: disposeBag)
    }

    func bindInfo(viewModel: ViewModelType) {
        viewCategories.enumerated().forEach { index, view in
            viewModel.categoriesCount
                .compactMap { $0[safe: index] }
                .bind(to: view.rx.count)
                .disposed(by: disposeBag)
            view.whenTapped()
                .map { _ in .selectCategory(index) }
                .bind(to: viewModel.actions)
                .disposed(by: disposeBag)
        }
    }
}

extension SpinningViewController {
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
            imageViewEdit = UIImageView(image: #imageLiteral(resourceName: "btn_slice")).then { v in
                v.contentMode = .scaleAspectFit
            }.layout(v) { m in
                m.top.right.bottom.equalToSuperview()
                m.left.equalTo(labelTitle.snp.right).offset(10)
                m.width.height.equalTo(40)
            }
        }.layout(viewTitle) { m in
            m.center.equalToSuperview()
        }

        let viewCenter = UIView().layout(parent) { m in
            m.top.equalTo(viewTitle.snp.bottom)
            m.left.right.equalToSuperview()
        }
        circularView = CircularView()
        circularView.layout(viewCenter) { m in
            m.top.greaterThanOrEqualToSuperview()
            m.bottom.lessThanOrEqualToSuperview()
            m.left.right.equalToSuperview().inset(25)
            m.centerY.equalToSuperview()
            m.height.equalTo(circularView.snp.width)
        }
        UIImageView(image: #imageLiteral(resourceName: "btn_start_disabled")).layout(parent) { m in
            m.center.equalTo(circularView)
        }
        viewAnimate = UIImageView(image: #imageLiteral(resourceName: "btn_start")).then { v in
            v.layer.applySketchShadow(color: 0xFD4145.color, alpha: 0.3, x: 5, y: 5, blur: 10)
        }.layout(parent) { m in
            m.center.equalTo(circularView)
        }

        let viewBottom = UIView().then { v in
            v.backgroundColor = 0x141414.color
        }.layout(parent) { m in
            m.top.equalTo(viewCenter.snp.bottom)
            m.left.right.equalToSuperview()
            m.bottom.equalTo(parent.safeAreaLayoutGuide)
        }
        layoutBottom(parent: viewBottom)
    }

    private func layoutBottom(parent: UIView) {
        let labelTitle = UILabel().then { v in
            v.text = "카테고리"
            v.font = .sdgothicneo(size: 18, weight: .bold)
            v.textColor = .rgbFFFFFF
        }.layout(parent) { m in
            m.top.equalToSuperview().inset(22)
            m.left.equalToSuperview().inset(20)
        }

        viewCategories = Category.allCases.map(CategoryView.init)
        let stackViewFirst = UIStackView(
            arrangedSubviews: Array(viewCategories.prefix(3))
        ).then { v in
            v.axis = .horizontal
            v.alignment = .fill
            v.distribution = .fillEqually
            v.spacing = 10
        }.layout(parent) { m in
            m.top.equalTo(labelTitle.snp.bottom).offset(22)
            m.left.right.equalToSuperview().inset(20)
            m.height.equalTo(40)
        }
        UIStackView(
            arrangedSubviews: Array(viewCategories.suffix(3))
        ).then { v in
            v.axis = .horizontal
            v.alignment = .fill
            v.distribution = .fillEqually
            v.spacing = 10
        }.layout(parent) { m in
            m.top.equalTo(stackViewFirst.snp.bottom).offset(10)
            m.left.right.equalToSuperview().inset(20)
            m.bottom.equalToSuperview().inset(10)
            m.height.equalTo(40)
        }
    }
}
