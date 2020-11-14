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
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private(set) var didSetupConstraints = false

    override func viewDidLoad() {
        view.setNeedsUpdateConstraints()
    }

    override func updateViewConstraints() {
        if !didSetupConstraints {
            didSetupConstraints = true
            layout(parent: view)
        }
        super.updateViewConstraints()
    }

    func layout(parent: UIView) {}
}
