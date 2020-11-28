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

    private var spinning = SpinningViewController()
    private var category = CategoryViewController()

    private var viewTitle: UIView!
    private var labelTitle: UILabel!
    private var viewBlacklist: UIView!

    private var viewContainer: UIView!

    override func layout(parent: UIView) {
        layoutContent(parent: parent)
    }

    func bind(viewModel: ViewModelType) {
        bindNavigation(viewModel: viewModel)
        bindChilds(viewModel: viewModel)
        bindPresentable(viewModel: viewModel)
    }

    private func addChild(viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        addChild(viewController)
        viewContainer.addSubview(viewController.view)
        viewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        viewController.didMove(toParent: self)
    }

    private func removeChild(viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        viewController.willMove(toParent: nil)
        viewController.removeFromParent()
        viewController.view.removeFromSuperview()
    }
}

extension MainViewController {
    func bindNavigation(viewModel: ViewModelType) {
        viewModel.titleText
            .bind(to: labelTitle.rx.text)
            .disposed(by: disposeBag)

        viewTitle.whenTapped()
            .map { _ in .address }
            .bind(to: viewModel.actions)
            .disposed(by: disposeBag)
    }

    func bindChilds(viewModel: ViewModelType) {
        let spinningViewModel = SpinningViewModel(serviceProvider: viewModel.serviceProvider)
        spinning.viewModel = spinningViewModel
        spinning.imageViewEdit.whenTapped()
            .map { _ in .category }
            .bind(to: viewModel.actions)
            .disposed(by: disposeBag)
        viewModel.coordinate
            .filterNil()
            .map { .setCoordinate($0) }
            .bind(to: spinningViewModel.actions)
            .disposed(by: disposeBag)

        let categoryViewModel = CategoryViewModel(serviceProvider: viewModel.serviceProvider)
        categoryViewModel.onAction = { categories in
            spinningViewModel.actions.accept(.setCategories(categories))
            viewModel.actions.accept(.spinning)
        }
        category.viewModel = categoryViewModel

        viewModel.selectedChild
            .map { [weak self] tab -> UIViewController in
                guard let self = self else { return .init() }
                switch tab {
                case .spinning: return self.spinning
                case .category: return self.category
                }
            }
            .withPrevious()
            .subscribe(onNext: { [weak self] previous, next in
                guard let self = self else { return }
                self.removeChild(viewController: previous)
                self.addChild(viewController: next)
            })
            .disposed(by: disposeBag)
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

        let viewNavigation = UIView().then { v in
            v.backgroundColor = 0x141414.color
            viewTitle = UIView().then { v in
                labelTitle = UILabel().then { v in
                    v.text = "서울 관악구 신림동 538"
                    v.textColor = .white
                    v.font = .sdgothicneo(size: 17, weight: .medium)
                    v.textAlignment = .center
                }.layout(v) { m in
                    m.top.left.bottom.equalToSuperview()
                }
                UIImageView(image: #imageLiteral(resourceName: "ic_arrow_down_16")).then { v in
                    v.contentMode = .scaleAspectFit
                }.layout(v) { m in
                    m.left.equalTo(labelTitle.snp.right).offset(4)
                    m.right.centerY.equalToSuperview()
                }
            }.layout(v) { m in
                m.left.equalToSuperview().inset(20)
                m.centerY.equalToSuperview()
            }
            viewBlacklist = UIImageView(image: #imageLiteral(resourceName: "ic_blacklist")).then { v in
                v.contentMode = .scaleAspectFit
            }.layout(v) { m in
                m.right.equalToSuperview().inset(20)
                m.centerY.equalToSuperview()
                m.width.height.equalTo(30)
            }
        }.layout(parent) { m in
            m.top.equalTo(parent.safeAreaLayoutGuide)
            m.left.right.equalToSuperview()
            m.height.equalTo(44)
        }

        viewContainer = UIView().then { v in
            v.backgroundColor = .clear
        }.layout(parent) { m in
            m.top.equalTo(viewNavigation.snp.bottom)
            m.left.right.bottom.equalToSuperview()
        }
        UIImageView(image: #imageLiteral(resourceName: "image_main_background")).layout(parent, below: viewContainer) { m in
            m.top.equalTo(viewNavigation.snp.bottom)
            m.left.right.equalToSuperview()
        }
    }
}
