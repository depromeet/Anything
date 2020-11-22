//
//  CategoryViewModel.swift
//  Anything
//
//  Created by Soso on 2020/11/22.
//  Copyright © 2020 Soso. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

enum CategoryAction {
    case toggleCategory(Category)
    case cancel, save
}

class CategoryViewModel: BaseViewModel {
    let actions = PublishRelay<CategoryAction>()

    let categoryList: Observable<[Category]>
    let selectedList: Observable<[Category]>

    var onAction: ([Category]) -> Void = { _ in }

    override init(serviceProvider: ServiceProviderType) {
        let categories = Category.allCases
        let categoryList = BehaviorRelay<[Category]>(value: categories)
        self.categoryList = categoryList.asObservable().distinctUntilChanged()
        let selectedList = BehaviorRelay<[Category]>(value: categories)
        self.selectedList = selectedList.asObservable().distinctUntilChanged()

        super.init(serviceProvider: serviceProvider)

        actions
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                switch action {
                case let .toggleCategory(value):
                    var selected = selectedList.value
                    if let index = selected.firstIndex(of: value) {
                        selected.remove(at: index)
                    } else {
                        selected.append(value)
                    }
                    selectedList.accept(selected)
                case .cancel:
                    self.onAction([])
                case .save:
                    let categories = categoryList.value
                        .filter { selectedList.value.contains($0) }
                    self.onAction(categories)
                }
            })
            .disposed(by: disposeBag)
    }
}
