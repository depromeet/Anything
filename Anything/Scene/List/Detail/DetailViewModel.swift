//
//  DetailViewModel.swift
//  Anything
//
//  Created by Soso on 2020/11/29.
//  Copyright © 2020 Soso. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

enum DetailAction {
    case back, location
}

class DetailViewModel: BaseViewModel {
    let actions = PublishRelay<DetailAction>()

    let cameraPosition: Observable<Coordinate>
    let authorizationStatus: Observable<AuthorizationStatus>

    let items: Observable<[DetailSection]> = BehaviorRelay(value: [
        DetailSection.menu([
            .menuHeader,
            .menuItem(.init(price: "33,000", menu: "수제 훈제 연어")),
            .menuItem(.init(price: "32,000", menu: "생 연어회")),
            .menuItem(.init(price: "19,000", menu: "베이컨 크림 홍합")),
        ]),
    ]).asObservable()

    init(
        serviceProvider: ServiceProviderType,
        location: Location
    ) {
        let cameraPosition = PublishRelay<Coordinate>()
        self.cameraPosition = cameraPosition.asObservable()
        let authorizationStatus = BehaviorRelay<AuthorizationStatus>(value: .denied)
        self.authorizationStatus = authorizationStatus.asObservable()

        super.init(serviceProvider: serviceProvider)

        actions
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .back:
                    self.presentable.accept(.pop)
                case .location:
                    guard authorizationStatus.value != .denied else {
                        self.presentable.accept(.alert("위치 권한", "위치 권한이 없습니다. 위치 권한을 활성화하러 가시겠습니까?") {
                            self.presentable.accept(.openAppSetting)
                        })
                        return
                    }
                    serviceProvider.locationService
                        .requestCoordinate()
                        .filterNil()
                        .take(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
                        .bind(to: cameraPosition)
                        .disposed(by: self.disposeBag)
                }
            })
            .disposed(by: disposeBag)

        serviceProvider.locationService.requestAuthorizationStatus()
            .map { $0.status }
            .bind(to: authorizationStatus)
            .disposed(by: disposeBag)
    }
}
