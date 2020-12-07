//
//  CategoryView.swift
//  Anything
//
//  Created by Soso on 2020/11/15.
//  Copyright © 2020 Soso. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class CategoryView: UIView {
    private let category: Category
    private var imageViewIcon: UIImageView!
    private var labelCount: UILabel!

    var count: Int = 0 {
        didSet {
            labelCount.text = "\(count)개"
        }
    }

    init(category: Category) {
        self.category = category
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = 0x282828.color
        layer.cornerRadius = 8
        layer.masksToBounds = true
        imageViewIcon = UIImageView().then { v in
            v.image = category.iconSmall
            v.contentMode = .scaleAspectFit
        }.layout(self) { m in
            m.top.bottom.equalToSuperview()
            m.left.equalToSuperview().inset(8)
            m.width.equalTo(30)
        }
        labelCount = UILabel().then { v in
            v.textColor = .white
            v.font = UIFont.sdgothicneo(size: 14, weight: .bold)
            v.textAlignment = .right
        }.layout(self) { m in
            m.left.equalTo(imageViewIcon.snp.right).offset(0)
            m.right.equalToSuperview().inset(8)
            m.centerY.equalToSuperview()
        }
    }
}

extension Reactive where Base: CategoryView {
    var count: Binder<Int> {
        return Binder(base) { view, count in
            view.count = count
        }
    }
}
