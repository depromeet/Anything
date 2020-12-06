//
//  ListLocationViewModel.swift
//  Anything
//
//  Created by Soso on 2020/12/01.
//  Copyright © 2020 Soso. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

enum ListLocationAction {
    case fetch
}

class ListLocationViewModel: BaseViewModel {
    let actions = PublishRelay<ListLocationAction>()

    let location: Location
    var detail: Detail?

    let keyText: String
    let titleText: String
    let ratingText: Observable<String>
    let ratingCountText: Observable<String>
    let reviewText: Observable<String>
    let addressText: String
    let imageUrlString: Observable<String>

    private var didFetch: Bool = false

    init(
        serviceProvider: ServiceProviderType,
        location: Location
    ) {
        self.location = location

        keyText = location.id
        titleText = location.placeName
        let ratingText = BehaviorRelay(value: "")
        self.ratingText = ratingText.asObservable()
        let ratingCountText = BehaviorRelay(value: "")
        self.ratingCountText = ratingCountText.asObservable()
        let reviewText = BehaviorRelay(value: "")
        self.reviewText = reviewText.asObservable()
        addressText = location.roadAddressName
        let imageUrlString = BehaviorRelay(value: "")
        self.imageUrlString = imageUrlString.asObservable()

        super.init(serviceProvider: serviceProvider)

        actions
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .fetch:
                    guard !self.didFetch else { return }
                    self.didFetch = true
                    serviceProvider.networkService.request(.detail(location.id), type: Detail.self, #file, #function, #line)
                        .subscribe(onSuccess: { [weak self] detail in
                            let sum = Double(detail.comment.scoresum)
                            let count = Double(detail.comment.scorecnt)
                            let avg = sum / max(count, 1)
                            ratingText.accept(String(format: "%.1f", avg))
                            ratingCountText.accept("\(detail.comment.scorecnt)")
                            reviewText.accept("리뷰 \(detail.blogReview?.blogrvwcnt ?? 0)")
                            imageUrlString.accept(detail.basicInfo?.mainphotourl ?? "")
                            self?.detail = detail
                        })
                        .disposed(by: self.disposeBag)
                }
            })
            .disposed(by: disposeBag)
    }
}
