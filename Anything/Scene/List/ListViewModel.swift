//
//  ListViewModel.swift
//  Anything
//
//  Created by Soso on 2020/11/29.
//  Copyright © 2020 Soso. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

enum ListAction {
    case back, loadMore
}

class ListViewModel: BaseViewModel {
    let actions = PublishRelay<ListAction>()

    let category: Observable<Category>
    let coordinate: Observable<Coordinate>
    let distance: Observable<Distance>
    let locationList: Observable<[ListLocationViewModel]>

    let addressText: Observable<String>
    let categoryText: Observable<String>
    let distanceText: Observable<String>

    private var currentPage: Int = 1
    private var isLoading: Bool = false
    private var isLast: Bool = false

    init(
        serviceProvider: ServiceProviderType,
        category: Category,
        coordinate: Coordinate,
        distance: Distance,
        locations: [Location]
    ) {
        let category = BehaviorRelay<Category>(value: category)
        self.category = category.asObservable()
        let coordinate = BehaviorRelay<Coordinate>(value: coordinate)
        self.coordinate = coordinate.asObservable()
        let distance = BehaviorRelay<Distance>(value: distance)
        self.distance = distance.asObservable()
        let locationList = BehaviorRelay<[ListLocationViewModel]>(value: locations.map { ListLocationViewModel(serviceProvider: serviceProvider, location: $0) })
        self.locationList = locationList.asObservable()

        let addressText = BehaviorRelay(value: "")
        self.addressText = addressText.asObservable()
        let categoryText = BehaviorRelay(value: category.value.name)
        self.categoryText = categoryText.asObservable()
        let distanceText = BehaviorRelay(value: distance.value.titleText)
        self.distanceText = distanceText.asObservable()

        super.init(serviceProvider: serviceProvider)

        actions
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .back:
                    self.presentable.accept(.pop)
                case .loadMore:
                    guard !self.isLoading else { return }
                    guard !self.isLast else { return }
                    self.isLoading = true
                    self.currentPage += 1
                    serviceProvider.networkService
                        .request(.search(category.value.rawValue, coordinate.value.latitude, coordinate.value.longitude, distance.value.rawValue, self.currentPage), type: List<Location>.self, #file, #function, #line)
                        .do(onSuccess: { [weak self] in self?.isLast = $0.meta.isEnd })
                        .map { $0.documents }
                        .map { $0.map { ListLocationViewModel(serviceProvider: serviceProvider, location: $0) } }
                        .do(onDispose: { [weak self] in self?.isLoading = false })
                        .subscribe(onSuccess: { locations in
                            let current = locationList.value
                            locationList.accept(current + locations)
                        })
                        .disposed(by: self.disposeBag)
                }
            })
            .disposed(by: disposeBag)

        coordinate
            .flatMap(serviceProvider.locationService.requestName)
            .bind(to: addressText)
            .disposed(by: disposeBag)
    }
}
