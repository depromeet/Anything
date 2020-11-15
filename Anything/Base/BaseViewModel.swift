//
//  BaseViewModel.swift
//  d.code
//
//  Created by iamchiwon on 2018. 5. 9..
//  Copyright © 2018년 n.code. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class BaseViewModel: Disposable {
    var disposeBag = DisposeBag()
    let presentable = PublishRelay<PresentableType>()
    let serviceProvider: ServiceProviderType

    init(serviceProvider: ServiceProviderType) {
        self.serviceProvider = serviceProvider
        setup()
    }

    func dispose() {
        disposeBag = DisposeBag()
    }

    func setup() {
    }
}
