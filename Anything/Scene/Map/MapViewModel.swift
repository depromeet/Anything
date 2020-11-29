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
    case setCoordinate(Coordinate)
}

class MapViewModel: BaseViewModel {
    let actions = PublishRelay<MapAction>()

    let titleText: Observable<String>
    let coordinate: Observable<Coordinate?>

    var onSelect: (Coordinate) -> Void = { _ in }

    override init(serviceProvider: ServiceProviderType) {
        let titleText = BehaviorRelay(value: "")
        self.titleText = titleText.asObservable()
        let coordinate = BehaviorRelay<Coordinate?>(value: nil)
        self.coordinate = coordinate.asObservable()

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
                case let .setCoordinate(newCoordinate):
                    coordinate.accept(newCoordinate)
                }
            })
            .disposed(by: disposeBag)

        serviceProvider.locationService
            .requestCoordinate()
            .bind(to: coordinate)
            .disposed(by: disposeBag)

        coordinate
            .filterNil()
            .throttle(.milliseconds(1000), latest: true, scheduler: MainScheduler.instance)
            .flatMap(serviceProvider.locationService.requestName)
            .bind(to: titleText)
            .disposed(by: disposeBag)
    }
}
