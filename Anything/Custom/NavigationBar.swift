//
//  NavigationBar.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/03.
//  Copyright © 2020 Soso. All rights reserved.
//

import SnapKit
import Then
import UIKit

class NavigationBar: UIView {
    init(
        titleView: UIView? = nil,
        leftView: UIView? = nil,
        rightViews: [UIView] = []
    ) {
        super.init(frame: .zero)
        setupViews(titleView: titleView, leftView: leftView, rightViews: rightViews)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let stackViewRight = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }

    func setupViews(
        titleView: UIView?,
        leftView: UIView?,
        rightViews: [UIView]
    ) {
        if let title = titleView {
            addSubview(title)
            title.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(60)
            }
        }
        if let left = leftView {
            addSubview(left)
            left.snp.makeConstraints {
                $0.top.bottom.equalToSuperview().inset(7)
                $0.leading.equalToSuperview().inset(20)
                $0.width.equalTo(left.snp.height)
            }
        }
        if !rightViews.isEmpty {
            addSubview(stackViewRight)
            stackViewRight.snp.makeConstraints {
                $0.top.bottom.equalToSuperview().inset(7)
                $0.trailing.equalToSuperview().inset(20)
            }
            for rightView in rightViews {
                stackViewRight.addArrangedSubview(rightView)
                rightView.snp.makeConstraints {
                    $0.width.equalTo(rightView.snp.height)
                }
            }
        }
    }
}
