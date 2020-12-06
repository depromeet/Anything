//
//  RandomViewModel.swift
//  Anything
//
//  Created by Soso on 2020/12/06.
//  Copyright © 2020 Soso. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

enum RandomAction {
    case close
    case detail
    case random
}

class RandomViewModel: BaseViewModel {
    let actions = PublishRelay<RandomAction>()

    let detailViewModel: Observable<DetailViewModel>
    let location: Observable<Location>
    let detail: Observable<Detail>

    var onDetail: (Location, Detail) -> Void = { _, _ in }
    var onReload: (() -> Observable<(Location, Detail)>)?

    init(
        serviceProvider: ServiceProviderType,
        coordinate: Coordinate,
        location: Location,
        detail: Detail
    ) {
        let detailViewModel = BehaviorRelay<DetailViewModel>(value: .init(serviceProvider: serviceProvider, coordinate: coordinate, location: location, detail: detail))
        self.detailViewModel = detailViewModel.asObservable()
        let location = BehaviorRelay<Location>(value: location)
        self.location = location.asObservable()
        let detail = BehaviorRelay<Detail>(value: detail)
        self.detail = detail.asObservable()

        super.init(serviceProvider: serviceProvider)

        actions
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .close:
                    self.presentable.accept(.dismiss())
                case .detail:
                    self.presentable.accept(.dismiss { [weak self] in
                        self?.onDetail(location.value, detail.value)
                    })
                case .random:
                    self.onReload?()
                        .subscribe(onNext: { newLocation, newDetail in
                            location.accept(newLocation)
                            detail.accept(newDetail)
                            detailViewModel.accept(.init(serviceProvider: serviceProvider, coordinate: coordinate, location: newLocation, detail: newDetail))
                        })
                        .disposed(by: self.disposeBag)
                }
            })
            .disposed(by: disposeBag)
    }
}
