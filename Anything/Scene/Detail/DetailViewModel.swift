//
//  DetailViewModel.swift
//  Anything
//
//  Created by Soso on 2020/11/29.
//  Copyright © 2020 Soso. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

enum DetailAction {
    case back, location
}

class DetailViewModel: BaseViewModel {
    let actions = PublishRelay<DetailAction>()

    let detail: Observable<Detail>
    let items: Observable<[DetailSection]>

    let cameraPosition: Observable<Coordinate>
    let authorizationStatus: Observable<AuthorizationStatus>

    init(
        serviceProvider: ServiceProviderType,
        location: Location,
        detail: Detail
    ) {
        let detail = BehaviorRelay<Detail>(value: detail)
        self.detail = detail.asObservable()
        let items = BehaviorRelay<[DetailSection]>(value: [])
        self.items = items.asObservable()

        let cameraPosition = PublishRelay<Coordinate>()
        self.cameraPosition = cameraPosition.asObservable()
        let authorizationStatus = BehaviorRelay<AuthorizationStatus>(value: .denied)
        self.authorizationStatus = authorizationStatus.asObservable()

        super.init(serviceProvider: serviceProvider)

        actions
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .back:
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
                        .bind(to: cameraPosition)
                        .disposed(by: self.disposeBag)
                }
            })
            .disposed(by: disposeBag)

        serviceProvider.locationService.requestAuthorizationStatus()
            .map { $0.status }
            .bind(to: authorizationStatus)
            .disposed(by: disposeBag)

        detail
            .map { [weak self] detail -> [DetailSection] in
                guard let self = self else { return [] }
                return [
                    self.mapMenu(detail: detail),
                    self.mapComment(detail: detail),
                    self.mapReview(detail: detail),
                ].compactMap { $0 }
            }
            .bind(to: items)
            .disposed(by: disposeBag)
    }

    func mapMenu(detail: Detail) -> DetailSection? {
        guard let menuList = detail.menuInfo?.menuList else { return nil }
        let list = menuList.map(DetailSectionItem.menuItem)
        guard !list.isEmpty else { return nil }
        return .detail([.menuHeader, .menuSeparator] + list + [.menuSeparator])
    }

    func mapComment(detail: Detail) -> DetailSection? {
        guard let commentList = detail.comment.list else { return nil }
        let list = commentList.map(DetailSectionItem.commentItem)
        guard !list.isEmpty else { return nil }
        return .detail([.commentHeader(detail.comment)] + list)
    }

    func mapReview(detail: Detail) -> DetailSection? {
        guard let review = detail.blogReview else { return nil }
        guard let reviewList = review.list else { return nil }
        let list = reviewList.map(DetailSectionItem.reviewItem)
        guard !list.isEmpty else { return nil }
        return .detail([.reviewHeader(review)] + list)
    }
}
