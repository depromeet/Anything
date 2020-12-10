//
//  SplashViewController.swift
//  Anything
//
//  Created by Soso on 2020/12/09.
//  Copyright © 2020 Soso. All rights reserved.
//

import Lottie
import RxSwift
import UIKit

class SplashViewController: UIViewController {
    var onAnimationCompletion: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .rgbFD4145
        let animationView = AnimationView(name: "splash").layout(view) { m in
            m.center.equalToSuperview()
        }
        _ = rx.viewDidAppear.take(1)
            .subscribe(onNext: { [weak self] _ in
                animationView.play { _ in
                    self?.onAnimationCompletion?(false)
                }
            })
    }
}
