//
//  MainViewModel.swift
//  Anything
//
//  Created by Soso on 2020/11/14.
//  Copyright © 2020 Soso. All rights reserved.
//

import CoreLocation
import Foundation
import RxCocoa
import RxOptional
import RxSwift

enum MainAction {
    case spinning, category
}

enum MainTab {
    case spinning, category
}

class MainViewModel: BaseViewModel {
    let actions = PublishRelay<MainAction>()

    let selectedChild: Observable<MainTab>

    override init(serviceProvider: ServiceProviderType) {
        let selectedChild = BehaviorRelay<MainTab>(value: .spinning)
        self.selectedChild = selectedChild.asObservable().distinctUntilChanged()

        super.init(serviceProvider: serviceProvider)

        actions
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .spinning:
                    selectedChild.accept(.spinning)
                case .category:
                    selectedChild.accept(.category)
                }
            })
            .disposed(by: disposeBag)
    }
}
