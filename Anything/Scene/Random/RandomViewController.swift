//
//  RandomViewController.swift
//  Anything
//
//  Created by Soso on 2020/12/06.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit

class RandomViewController: BaseViewController, View {
    typealias ViewModelType = RandomViewModel

    private var viewContainer: UIView!
    private var viewRandom: UIView!
    private var imageViewClose: UIImageView!

    private let detail = DetailViewController()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layout(parent: UIView) {
        layoutContent(parent: parent)
    }

    func bind(viewModel: ViewModelType) {
        bindAction(viewModel: viewModel)
        bindDetail(viewModel: viewModel)
        bindPresentable(viewModel: viewModel)
    }
}

extension RandomViewController {
    func bindAction(viewModel: ViewModelType) {
        imageViewClose.whenTapped()
            .map { _ in .close }
            .bind(to: viewModel.actions)
            .disposed(by: disposeBag)
        viewContainer.whenTapped()
            .map { _ in .detail }
            .bind(to: viewModel.actions)
            .disposed(by: disposeBag)
        viewRandom.whenTapped()
            .map { _ in .random }
            .bind(to: viewModel.actions)
            .disposed(by: disposeBag)
    }

    func bindDetail(viewModel: ViewModelType) {
        viewModel.detailViewModel
            .subscribe(onNext: { [weak self] viewModel in
                self?.detail.viewModel = viewModel
            })
            .disposed(by: disposeBag)
    }
}

extension RandomViewController {
    private func layoutContent(parent: UIView) {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)

        viewContainer = UIView().then { v in
            v.backgroundColor = .white
            v.layer.cornerRadius = 20
            v.layer.masksToBounds = true

            detail.view.layout(v) { m in
                m.edges.equalToSuperview()
                m.width.equalToSuperview()
            }
            detail.imageViewBack.isHidden = true
            detail.view.isUserInteractionEnabled = false
        }.layout(parent) { m in
            m.top.equalToSuperview().inset(100)
            m.left.right.equalToSuperview().inset(20)
        }

        imageViewClose = UIImageView(image: #imageLiteral(resourceName: "btn_cancel")).then { v in
            v.contentMode = .center
        }.layout(parent) { m in
            m.bottom.equalTo(viewContainer.snp.top).offset(-10)
            m.centerX.equalToSuperview()
        }

        viewRandom = UIView().then { v in
            v.layer.applySketchShadow(color: .rgbFD4145, alpha: 0.3, x: 5, y: 5, blur: 10)

            UILabel().then { v in
                v.font = .subtitle3
                v.text = "다시 골라주세요!"
                v.textColor = .rgbFFFFFF
                v.textAlignment = .center
                v.backgroundColor = .rgbFD4145
                v.layer.cornerRadius = 8
                v.layer.masksToBounds = true
            }.layout(v) { m in
                m.edges.equalToSuperview()
            }
        }.layout(parent) { m in
            m.top.equalTo(viewContainer.snp.bottom).offset(16)
            m.left.right.equalToSuperview().inset(20)
            m.bottom.equalTo(parent.safeAreaLayoutGuide).inset(14)
            m.height.equalTo(48)
        }
    }
}
