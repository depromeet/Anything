//
//  OnTap.swift
//  d.code
//
//  Created by iamchiwon on 2017. 7. 26..
//  Copyright © 2017년 n.code. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension UIView {
    func whenTapped(_ numberOfTapsRequired: Int = 1) -> Observable<UITapGestureRecognizer> {
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = numberOfTapsRequired
        addGestureRecognizer(tapGesture)
        return tapGesture.rx.event.asObservable()
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
    }

    func whenPan() -> Observable<UIPanGestureRecognizer> {
        isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer()
        addGestureRecognizer(panGesture)
        return panGesture.rx.event.asObservable()
    }
}
