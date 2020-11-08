//
//  ViewController.swift
//  Anything
//
//  Created by Soso on 2020/10/23.
//  Copyright © 2020 Soso. All rights reserved.
//

import SnapKit
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hex: 0x383838)

        let circularView = CircularView()
        view.addSubview(circularView)
        circularView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(300)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
