//
//  BaseViewModel.swift
//  d.code
//
//  Created by iamchiwon on 2018. 5. 9..
//  Copyright © 2018년 n.code. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel: Disposable {
    var disposeBag = DisposeBag()
    let presentable = PublishRelay<PresentableType>()
    
    init() {
        setup()
    }
    
    func dispose() {
        disposeBag = DisposeBag()
    }
    
    func setup() {
    }
}
