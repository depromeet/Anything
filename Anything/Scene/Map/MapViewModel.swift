//
//  MapViewModel.swift
//  Anything
//
//  Created by Soso on 2020/11/28.
//  Copyright © 2020 Soso. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

enum MapAction {
    case back
    case save
    case location
    case setCoordinate(Coordinate)
}

class MapViewModel: BaseViewModel {
    let actions = PublishRelay<MapAction>()

    let titleText: Observable<String>
    let coordinate: Observable<Coordinate?>
    let newCoordinate: Observable<Coordinate>
    let authorizationStatus: Observable<AuthorizationStatus>

    var onSelect: (Coordinate) -> Void = { _ in }

    override init(serviceProvider: ServiceProviderType) {
        let titleText = BehaviorRelay(value: "")
        self.titleText = titleText.asObservable()
        let coordinate = BehaviorRelay<Coordinate?>(value: nil)
        self.coordinate = coordinate.asObservable()
        let newCoordinate = PublishRelay<Coordinate>()
        self.newCoordinate = newCoordinate.asObservable()
        let authorizationStatus = BehaviorRelay<AuthorizationStatus>(value: .denied)
        self.authorizationStatus = authorizationStatus.asObservable()

        super.init(serviceProvider: serviceProvider)

        actions
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .back:
                    self.presentable.accept(.pop)
                case .save:
                    guard let coordinate = coordinate.value else { return }
                    self.onSelect(coordinate)
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
                        .bind(to: newCoordinate)
                        .disposed(by: self.disposeBag)
                case let .setCoordinate(newCoordinate):
                    coordinate.accept(newCoordinate)
                }
            })
            .disposed(by: disposeBag)

        coordinate
            .filterNil()
            .throttle(.milliseconds(1000), latest: true, scheduler: MainScheduler.instance)
            .flatMap(serviceProvider.locationService.requestName)
            .bind(to: titleText)
            .disposed(by: disposeBag)

        serviceProvider.locationService.requestAuthorizationStatus()
            .map { $0.status }
            .bind(to: authorizationStatus)
            .disposed(by: disposeBag)
    }
}
