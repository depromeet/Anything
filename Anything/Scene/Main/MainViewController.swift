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

    private var viewNavigation: UIView!
    private var viewContainer: UIView!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func layout(parent: UIView) {
        layoutContent(parent: parent)
    }

    func bind(viewModel: ViewModelType) {
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
    func bindChilds(viewModel: ViewModelType) {
        spinning.viewModel = .init(serviceProvider: viewModel.serviceProvider)

        viewModel.selectedChild
            .map { [weak self] tab -> UIViewController in
                guard let self = self else { return .init() }
                switch tab {
                case .spinning: return self.spinning
                case .category: return .init()
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
        let labelTitle = UILabel().then { v in
            v.text = "서울 관악구 신림동 538"
            v.textColor = .white
            v.font = .sdgothicneo(size: 17, weight: .medium)
            v.textAlignment = .center
        }
        viewNavigation = NavigationBar(
            titleView: labelTitle
        ).then { v in
            v.backgroundColor = 0x141414.color
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
    }
}
