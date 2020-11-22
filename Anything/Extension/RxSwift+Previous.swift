//
//  RxSwift+Previous.swift
//  d.code
//
//  Created by Soso on 2020/10/22.
//  Copyright © 2020 n.code. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    func withPrevious() -> Observable<(Element?, Element)> {
        return scan([], accumulator: { previous, current in
            Array(previous + [current]).suffix(2)
        })
            .map { (arr) -> (previous: Element?, current: Element) in
                (arr.count > 1 ? arr.first : nil, arr.last!)
            }
    }
}
