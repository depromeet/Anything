//
//  MainViewModel.swift
//  Anything
//
//  Created by Soso on 2020/11/14.
//  Copyright © 2020 Soso. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

enum MainAction {
    case animate
    case select(Int)
}

class MainViewModel: BaseViewModel {
    let actions = PublishRelay<MainAction>()

    let isAnimating: Observable<Bool>

    let currentIndex: Observable<Int>

    let categories: Observable<[Category]>
    let categoriesList: Observable<[[Restaurant]]>
    let categoriesCount: Observable<[Int]>

    override init(serviceProvider: ServiceProviderType) {
        let isAnimating = BehaviorRelay(value: false)
        self.isAnimating = isAnimating.asObservable()

        let currentIndex = BehaviorRelay(value: 0)
        self.currentIndex = currentIndex.asObservable()

        let categories = BehaviorRelay(value: Category.allCases)
        self.categories = categories.asObservable()
        let categoriesList = BehaviorRelay<[[Restaurant]]>(value: [])
        self.categoriesList = categoriesList.asObservable()
        let categoriesCount = BehaviorRelay<[Int]>(value: [])
        self.categoriesCount = categoriesCount.asObservable()

        super.init(serviceProvider: serviceProvider)

        actions
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .animate:
                    guard !isAnimating.value else { return }

                    let total = 500
                    let angle = 360 / categories.value.count
                    let start = Float(currentIndex.value * angle)
                    let random = Float.random(in: 0 ... 360)
                    Observable<Int>
                        .interval(.milliseconds(10), scheduler: MainScheduler.instance).take(total)
                        .map { value -> Float in
                            Cubic.EaseOut(Float(value), start, 360 * 5 - start + random, Float(total))
                        }
                        .map { Int($0 / Float(angle)) % categories.value.count }
                        .do(onSubscribe: {
                            isAnimating.accept(true)
                        }, onDispose: {
                            isAnimating.accept(false)
                        })
                        .bind(to: currentIndex)
                        .disposed(by: self.disposeBag)
                case let .select(index):
                    print(index)
                }
            })
            .disposed(by: disposeBag)

        Single
            .zip(Category.allCases
                .compactMap { [weak self] category in
                    self?.requestData(category: category, x: 127.108212, y: 37.402056, radius: 1000) ?? Single.just(([], 0))
                })
            .subscribe(onSuccess: { list in
                var restaurants: [[Restaurant]] = []
                var counts: [Int] = []
                for (restaurant, count) in list {
                    restaurants.append(restaurant)
                    counts.append(count)
                }
                categoriesList.accept(restaurants)
                categoriesCount.accept(counts)
            })
            .disposed(by: disposeBag)
    }

    private func requestData(
        category: Category,
        x: Double,
        y: Double,
        radius: Int
    ) -> Single<([Restaurant], Int)> {
        return serviceProvider.networkService
            .request(.search(category.name, x, y, radius, 1), type: List<Restaurant>.self, #file, #function, #line)
            .map { ($0.documents, $0.meta.totalCount) }
    }
}
