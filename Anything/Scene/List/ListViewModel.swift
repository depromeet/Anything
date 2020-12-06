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
    case back, loadMore, position(Int), location
}

class ListViewModel: BaseViewModel {
    let actions = PublishRelay<ListAction>()

    let category: Observable<Category>
    let cameraPosition: Observable<Coordinate>
    let currentPosition: Observable<Coordinate>
    let coordinate: Observable<Coordinate>
    let distance: Observable<Distance>
    let authorizationStatus: Observable<AuthorizationStatus>
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
        let cameraPosition = BehaviorRelay<Coordinate>(value: coordinate)
        self.cameraPosition = cameraPosition.asObservable()
        let currentPosition = BehaviorRelay<Coordinate>(value: coordinate)
        self.currentPosition = currentPosition.asObservable()
        let coordinate = BehaviorRelay<Coordinate>(value: coordinate)
        self.coordinate = coordinate.asObservable()
        let distance = BehaviorRelay<Distance>(value: distance)
        self.distance = distance.asObservable()
        let authorizationStatus = BehaviorRelay<AuthorizationStatus>(value: .denied)
        self.authorizationStatus = authorizationStatus.asObservable()
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
                case let .position(index):
                    guard let coordinate = locationList.value[safe: index]?.location.coordinate else { return }
                    cameraPosition.accept(coordinate)
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
                        .subscribe(onNext: { coordinate in
                            cameraPosition.accept(coordinate)
                            currentPosition.accept(coordinate)
                        })
                        .disposed(by: self.disposeBag)
                }
            })
            .disposed(by: disposeBag)

        coordinate
            .flatMap(serviceProvider.locationService.requestName)
            .bind(to: addressText)
            .disposed(by: disposeBag)

        serviceProvider.locationService.requestAuthorizationStatus()
            .map { $0.status }
            .bind(to: authorizationStatus)
            .disposed(by: disposeBag)
    }
}
