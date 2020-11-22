//
//  BaseTableViewCell.swift
//  Anything
//
//  Created by Soso on 2020/07/05.
//  Copyright © 2020 Soso. All rights reserved.
//

import RxSwift
import UIKit
import Reusable

class BaseTableViewCell: UITableViewCell, Reusable {
    var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout(parent: self)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout(parent: UIView) {}

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }
}
