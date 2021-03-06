//
//  SpinningViewModel.swift
//  Anything
//
//  Created by Soso on 2020/11/22.
//  Copyright © 2020 Soso. All rights reserved.
//

import CoreLocation
import Foundation
import RxCocoa
import RxOptional
import RxSwift

enum SpinningAction {
    case animate
    case changeDistance
    case selectCategory(Int)
    case setCategories([Category])
    case setCoordinate(Coordinate)
}

class SpinningViewModel: BaseViewModel {
    let actions = PublishRelay<SpinningAction>()

    let isAnimating: Observable<Bool>

    let currentIndex: Observable<Int>

    let categories: Observable<[Category]>
    let categoriesList: Observable<[[Location]]>
    let categoriesCount: Observable<[Int]>

    let distance: Observable<Distance>
    let coordinate: Observable<Coordinate?>

    override init(serviceProvider: ServiceProviderType) {
        let isAnimating = BehaviorRelay(value: false)
        self.isAnimating = isAnimating.asObservable()

        let currentIndex = BehaviorRelay(value: 0)
        self.currentIndex = currentIndex.asObservable()

        let categories = BehaviorRelay(value: Category.allCases)
        self.categories = categories.asObservable()
        let categoriesList = BehaviorRelay<[[Location]]>(value: [])
        self.categoriesList = categoriesList.asObservable()
        let categoriesCount = BehaviorRelay<[Int]>(value: [])
        self.categoriesCount = categoriesCount.asObservable()

        let distance = BehaviorRelay<Distance>(value: .nearest)
        self.distance = distance.asObservable()
        let coordinate = BehaviorRelay<Coordinate?>(value: nil)
        self.coordinate = coordinate.asObservable()

        super.init(serviceProvider: serviceProvider)

        actions
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .animate:
                    guard !isAnimating.value else { return }

                    let count = categories.value.count
                    let total = 100
                    let angle = 360 / count
                    let start = Float(currentIndex.value * angle)

                    let list = Category.allCases.enumerated()
                        .filter { categories.value.contains($0.element) && categoriesCount.value[safe: $0.offset] != 0 }
                        .map { $0.offset }
                    let random = Float((list.randomElement() ?? 0) * angle)
                    Observable<Int>
                        .interval(.milliseconds(50), scheduler: ConcurrentDispatchQueueScheduler(qos: .userInitiated)).take(total)
                        .map { value -> Float in
                            Cubic.EaseOut(Float(value), Float(angle / 2) + start, 360 * Float(12 - count) - start + random, Float(total))
                        }
                        .map { Int($0 / Float(angle)) % count }
                        .do(onSubscribe: {
                            isAnimating.accept(true)
                        }, onDispose: { [weak self] in
                            isAnimating.accept(false)
                            DispatchQueue.main.async {
                                guard let category = categories.value[safe: currentIndex.value] else { return }
                                let vc = ResultViewController(category: category)
                                vc.onResult = { result in
                                    guard result else { return }
                                    self?.actions.accept(.selectCategory(currentIndex.value))
                                }
                                self?.presentable.accept(.present(vc, nil))
                            }
                        })
                        .bind(to: currentIndex)
                        .disposed(by: self.disposeBag)
                case .changeDistance:
                    let vc = DistanceViewController(distances: Distance.allCases, selectedDistance: distance.value)
                    vc.rx.itemSelected
                        .distinctUntilChanged()
                        .compactMap { Distance.allCases[safe: $0.row] }
                        .bind(to: distance)
                        .disposed(by: vc.disposeBag)
                    self.presentable.accept(.panModal(vc))
                case let .selectCategory(index):
                    guard let category = categories.value[safe: index] else { return }
                    guard let coordinate = coordinate.value else { return }
                    guard let locations = categoriesList.value[safe: index] else { return }
                    guard let count = categoriesCount.value[safe: index] else { return }
                    guard !locations.isEmpty else { return}
                    let vc = ListViewController()
                    let viewModel = ListViewModel(
                        serviceProvider: serviceProvider,
                        category: category,
                        coordinate: coordinate,
                        distance: distance.value,
                        locations: locations,
                        totalCount: count
                    )
                    vc.viewModel = viewModel
                    self.presentable.accept(.push(vc))
                case let .setCategories(newCategories):
                    guard newCategories.count > 1 else { return }
                    categories.accept(newCategories)
                case let .setCoordinate(newCoordinate):
                    coordinate.accept(newCoordinate)
                }
            })
            .disposed(by: disposeBag)

        Observable
            .combineLatest(coordinate.filterNil(), distance.distinctUntilChanged())
            .flatMap { coordinate, distance in
                Single.zip(Category.allCases.map { category in
                    serviceProvider.networkService
                        .request(.search(category.rawValue, coordinate.latitude, coordinate.longitude, distance.rawValue, 1, 15), type: List<Location>.self, #file, #function, #line)
                        .map { ($0.documents, $0.meta.totalCount) }
                })
            }
            .subscribe(onNext: { list in
                var locations: [[Location]] = []
                var counts: [Int] = []
                for (location, count) in list {
                    locations.append(location)
                    counts.append(count)
                }
                categoriesList.accept(locations)
                categoriesCount.accept(counts)
            })
            .disposed(by: disposeBag)
    }
}
