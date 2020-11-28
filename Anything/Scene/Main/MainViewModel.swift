//
//  MainViewModel.swift
//  Anything
//
//  Created by Soso on 2020/11/14.
//  Copyright © 2020 Soso. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

enum MainAction {
    case address, spinning, category
}

enum MainTab {
    case spinning, category
}

class MainViewModel: BaseViewModel {
    let actions = PublishRelay<MainAction>()

    let selectedChild: Observable<MainTab>

    let coordinate: Observable<Coordinate?>

    override init(serviceProvider: ServiceProviderType) {
        let selectedChild = BehaviorRelay<MainTab>(value: .spinning)
        self.selectedChild = selectedChild.asObservable().distinctUntilChanged()

        let coordinate = BehaviorRelay<Coordinate?>(value: nil)
        self.coordinate = coordinate.asObservable()

        super.init(serviceProvider: serviceProvider)

        actions
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .address:
                    let vc = AddressViewController()
                    let viewModel = AddressViewModel(serviceProvider: serviceProvider)
                    viewModel.onSelect = { newCoordinate in
                        coordinate.accept(newCoordinate)
                    }
                    vc.viewModel = viewModel
                    self.presentable.accept(.push(vc))
                case .spinning:
                    selectedChild.accept(.spinning)
                case .category:
                    selectedChild.accept(.category)
                }
            })
            .disposed(by: disposeBag)

        serviceProvider.locationService
            .requestCoordinate()
            .bind(to: coordinate)
            .disposed(by: disposeBag)
    }
}
