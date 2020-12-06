//
//  ResultViewController.swift
//  Anything
//
//  Created by Soso on 2020/12/06.
//  Copyright © 2020 Soso. All rights reserved.
//

import RxSwift
import UIKit

class ResultViewController: BaseViewController {
    let category: Category

    var onResult: (Bool) -> Void = { _ in }

    init(category: Category) {
        self.category = category

        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layout(parent: UIView) {
        layoutContent(parent: parent)
    }
}

extension ResultViewController {
    private func layoutContent(parent: UIView) {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)

        let viewContainer = UIView().then { v in
            v.backgroundColor = .white
            v.layer.cornerRadius = 8
            v.layer.masksToBounds = true
        }.layout(parent) { m in
            m.left.right.equalToSuperview().inset(20)
            m.center.equalToSuperview()
            m.height.equalTo(124)
        }

        layoutContainer(parent: viewContainer)
    }

    private func layoutContainer(parent: UIView) {
        UIView().then { v in
            let imageViewIcon = UIImageView(image: category.iconSmall).then { v in
                v.contentMode = .center
            }.layout(v) { m in
                m.top.left.bottom.equalToSuperview()
            }
            UILabel().then { v in
                v.text = "\(category.name) 당첨!"
                v.textColor = .rgb3C3C3C
                v.font = UIFont.sdgothicneo(size: 22, weight: .bold)
            }.layout(v) { m in
                m.left.equalTo(imageViewIcon.snp.right).offset(4)
                m.top.right.bottom.equalToSuperview()
            }
        }.layout(parent) { m in
            m.top.equalToSuperview().inset(24)
            m.centerX.equalToSuperview()
        }

        let viewBottom = UIView().layout(parent) { m in
            m.left.right.bottom.equalToSuperview().inset(20)
        }
        layoutBottom(parent: viewBottom)
    }

    private func layoutBottom(parent: UIView) {
        let buttonCancel = UILabel().then { v in
            v.font = .subtitle3
            v.text = "다시 돌리기"
            v.textColor = .rgbFD4145
            v.textAlignment = .center
            v.backgroundColor = .clear
            v.layer.cornerRadius = 8
            v.layer.masksToBounds = true
            v.layer.borderColor = UIColor.rgbFD4145.cgColor
            v.layer.borderWidth = 1
        }
        let buttonShow = UILabel().then { v in
            v.font = .subtitle3
            v.text = "음식점 보기"
            v.textColor = .white
            v.textAlignment = .center
            v.backgroundColor = .rgbFD4145
            v.layer.cornerRadius = 8
            v.layer.masksToBounds = true
        }
        UIStackView(
            arrangedSubviews: [buttonCancel, buttonShow]
        ).then { v in
            v.axis = .horizontal
            v.distribution = .fillEqually
            v.alignment = .fill
            v.spacing = 10
        }.layout(parent) { m in
            m.edges.equalToSuperview()
            m.height.equalTo(40)
        }

        _ = Observable.of(
            buttonCancel.whenTapped().map { _ in false },
            buttonShow.whenTapped().map { _ in true }
        ).merge()
            .subscribe(onNext: { [weak self] result in
                self?.dismiss(animated: true, completion: {
                    self?.onResult(result)
                })
            })
    }
}
