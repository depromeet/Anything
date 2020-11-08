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
import UIKit

class MainViewController: UIViewController {
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hex: 0x262626)

        let circularView = CircularView()
        view.addSubview(circularView)
        circularView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(320)
        }

        let total = 500
        circularView.rx.tapGesture()
            .when(.recognized)
            .flatMap { _ -> Observable<CGFloat> in
                let random = CGFloat.random(in: 0 ... 360)
                return Observable<Int>
                    .interval(.milliseconds(10), scheduler: MainScheduler.instance).take(total)
                    .map { value -> CGFloat in
                        return Cubic.EaseOut(CGFloat(value), 0, 360 * 5 + random, CGFloat(total))
                    }
            }
            .map { Int($0 / 72) % 5 }
            .bind(to: circularView.rx.currentIndex)
            .disposed(by: disposeBag)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
