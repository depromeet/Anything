//
//  BaseViewController.swift
//  d.code
//
//  Created by iamchiwon on 2018. 2. 5..
//  Copyright © 2018년 n.code. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class BaseViewController: UIViewController {
    var disposeBag = DisposeBag()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        layout(parent: view)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout(parent: UIView) {}
}
