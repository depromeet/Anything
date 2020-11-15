//
//  MainViewController.swift
//  Anything
//
//  Created by Soso on 2020/10/23.
//  Copyright © 2020 Soso. All rights reserved.
//

import RxGesture
import RxSwift
import SnapKit
import SwiftyColor
import UIKit

class MainViewController: BaseViewController, View {
    typealias ViewModelType = MainViewModel

    private var circularView: CircularView!
    private var viewAnimate: UIImageView!
    private var viewCategories: [CategoryView]!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func layout(parent: UIView) {
        layoutContent(parent: parent)
    }

    func bind(viewModel: ViewModelType) {
        bindSpinningWheel(viewModel: viewModel)
        bindInfo(viewModel: viewModel)
        bindPresentable(viewModel: viewModel)
    }
}

extension MainViewController {
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
                .map { _ in .select(index) }
                .bind(to: viewModel.actions)
                .disposed(by: disposeBag)
        }
    }
}

extension MainViewController {
    private func layoutContent(parent: UIView) {
        view.backgroundColor = 0x141414.color

        UIView().then { v in
            v.backgroundColor = 0xE5E5E5.color
        }.layout(parent) { m in
            m.edges.equalTo(parent.safeAreaLayoutGuide)
        }
        let viewNavigation = NavigationBar(
            title: "서울 관악구 신림동 538"
        ).then { v in
            v.backgroundColor = 0x141414.color
        }.layout(parent) { m in
            m.top.equalTo(parent.safeAreaLayoutGuide)
            m.left.right.equalToSuperview()
            m.height.equalTo(44)
        }
        let imageViewBackground = UIImageView(image: #imageLiteral(resourceName: "image_main_background")).layout(parent) { m in
            m.top.equalTo(viewNavigation.snp.bottom)
            m.left.right.equalToSuperview()
        }

        circularView = CircularView().layout(parent) { m in
            m.top.equalTo(imageViewBackground.snp.bottom)
            m.centerX.equalToSuperview()
            m.width.height.equalTo(325)
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
            m.left.right.equalToSuperview()
            m.bottom.equalTo(parent.safeAreaLayoutGuide)
        }
        layoutBottom(parent: viewBottom)
    }

    private func layoutBottom(parent: UIView) {
        let labelTitle = UILabel().then { v in
            v.text = "바로가기"
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
