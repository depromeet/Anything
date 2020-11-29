//
//  AddressViewModel.swift
//  Anything
//
//  Created by Soso on 2020/11/28.
//  Copyright © 2020 Soso. All rights reserved.
//

import CoreLocation
import Foundation
import RxRelay
import RxSwift

enum AddressAction {
    case back
    case input(String)
    case current
    case map
    case selectLocation(Int)
}

class AddressViewModel: BaseViewModel {
    let actions = PublishRelay<AddressAction>()

    let locationList: Observable<[Location]>

    var onSelect: (Coordinate) -> Void = { _ in }

    override init(serviceProvider: ServiceProviderType) {
        let locationList = BehaviorRelay<[Location]>(value: [])
        self.locationList = locationList.asObservable()

        super.init(serviceProvider: serviceProvider)

        actions
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .back:
                    self.presentable.accept(.pop)
                case let .input(text):
                    serviceProvider.networkService
                        .request(.search(text, nil, nil, nil, 1), type: List<Location>.self, #file, #function, #line)
                        .map { $0.documents }
                        .asObservable()
                        .bind(to: locationList)
                        .disposed(by: self.disposeBag)
                case .current:
                    serviceProvider.locationService.requestCoordinate()
                        .filterNil()
                        .subscribe(onNext: { [weak self] coordinate in
                            self?.onSelect(coordinate)
                            self?.presentable.accept(.pop)
                        })
                        .disposed(by: self.disposeBag)
                case .map:
                    let vc = MapViewController()
                    let viewModel = MapViewModel(serviceProvider: serviceProvider)
                    viewModel.onSelect = { [weak self] newCoordinate in
                        self?.onSelect(newCoordinate)
                        self?.presentable.accept(.pop)
                    }
                    vc.viewModel = viewModel
                    self.presentable.accept(.push(vc))
                case let .selectLocation(index):
                    guard let location = locationList.value[safe: index] else { return }
                    guard let latitude = Double(location.y) else { return }
                    guard let longitude = Double(location.x) else { return }
                    let coordinate = Coordinate(latitude: latitude, longitude: longitude)
                    self.onSelect(coordinate)
                    self.presentable.accept(.pop)
                }
            })
            .disposed(by: disposeBag)
    }
}
