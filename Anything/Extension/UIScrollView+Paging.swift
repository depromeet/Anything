//
//  UIScrollView+Paging.swift
//  d.code
//
//  Created by iamchiwon on 2018. 3. 23..
//  Copyright © 2018년 n.code. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension UIScrollView {
    func whenBottomReached(before: Int = 1) -> Observable<CGFloat> {
        return rx
            .didScroll
            .asControlEvent()
            .map { self.contentSize.height - self.bounds.size.height - self.contentOffset.y }
            .filter { $0 < (self.bounds.size.height * CGFloat(before)) }
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
    }
}
