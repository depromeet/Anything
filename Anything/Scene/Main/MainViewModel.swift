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
    case address, spinning, category, firstLoad
}

enum MainTab {
    case spinning, category
}

class MainViewModel: BaseViewModel {
    let actions = PublishRelay<MainAction>()

    let selectedChild: Observable<MainTab>
    let titleText: Observable<String>

    let coordinate: Observable<Coordinate?>

    override init(serviceProvider: ServiceProviderType) {
        let selectedChild = BehaviorRelay<MainTab>(value: .spinning)
        self.selectedChild = selectedChild.asObservable().distinctUntilChanged()
        let titleText = BehaviorRelay(value: "현재 주소를 설정해주세요")
        self.titleText = titleText.asObservable()

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
                case .firstLoad:
                    serviceProvider.locationService.requestAuthorizationStatus()
                        .take(1)
                        .subscribe(onNext: { [weak self] event in
                            guard event.status == .denied else { return }
                            self?.presentable.accept(.alert("위치 권한", "위치 권한이 없습니다. 앱 설정에서 권한을 허용해주세요.") {
                                self?.presentable.accept(.openAppSetting)
                            })
                        })
                        .disposed(by: self.disposeBag)
                }
            })
            .disposed(by: disposeBag)

        serviceProvider.locationService
            .requestCoordinate()
            .bind(to: coordinate)
            .disposed(by: disposeBag)

        coordinate
            .filterNil()
            .flatMap(serviceProvider.locationService.requestName)
            .bind(to: titleText)
            .disposed(by: disposeBag)
    }
}
