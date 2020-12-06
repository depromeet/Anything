//
//  DetailViewController.swift
//  Anything
//
//  Created by Soso on 2020/11/29.
//  Copyright © 2020 Soso. All rights reserved.
//

import NMapsMap
import Reusable
import RxDataSources
import RxSwift
import UIKit

class DetailViewController: BaseViewController, View {
    typealias ViewModelType = DetailViewModel

    static var dataSource: RxTableViewSectionedReloadDataSource<DetailSection> {
        return .init(configureCell: { (_, tableView, indexPath, sectionItem) -> UITableViewCell in
            switch sectionItem {
            case .menuHeader:
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: DetailMenuHeaderCell.self)
                return cell
            case let .menuItem(item):
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: DetailMenuItemCell.self)
                cell.labelName.text = item.menu
                cell.labelPrice.text = item.price
                return cell
            case .menuSeparator:
                return tableView.dequeueReusableCell(for: indexPath, cellType: DetailMenuSeparatorCell.self)
            case let .commentHeader(item):
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: DetailCommentHeaderCell.self)
                cell.labelCount.text = "\(item.scorecnt)"
                let sum = Double(item.scoresum)
                let count = Double(item.scorecnt)
                let avg = sum / max(count, 1)
                cell.labelScore.text = String(format: "%.1f", avg) + "점"
                cell.viewRating.rating = avg
                return cell
            case let .commentItem(item):
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: DetailCommentItemCell.self)
                if let string = item.profile, let url = URL(string: string) {
                    cell.imageViewProfile.kf.setImage(with: url, options: [.transition(.fade(0.2))])
                }
                cell.viewRating.rating = Double(item.point ?? 0)
                cell.labelName.text = item.username
                cell.labelDate.text = item.date
                cell.labelContent.text = item.contents
                cell.labelContent.setLineSpacing(lineSpacing: 5)
                return cell
            case let .reviewHeader(item):
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: DetailReviewHeaderCell.self)
                cell.labelCount.text = "\(item.blogrvwcnt)"
                return cell
            case let .reviewItem(item):
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: DetailReviewItemCell.self)
                cell.labelTitle.text = item.title
                cell.labelContent.text = item.contents
                cell.labelContent.setLineSpacing(lineSpacing: 5)
                if let string = item.photoList?[safe: 0]?.orgurl, let url = URL(string: string) {
                    cell.imageView1.kf.setImage(with: url, options: [.transition(.fade(0.2))])
                }
                if let string = item.photoList?[safe: 1]?.orgurl, let url = URL(string: string) {
                    cell.imageView2.kf.setImage(with: url, options: [.transition(.fade(0.2))])
                }
                if let string = item.photoList?[safe: 2]?.orgurl, let url = URL(string: string) {
                    cell.imageView3.kf.setImage(with: url, options: [.transition(.fade(0.2))])
                }
                cell.labelName.text = item.blogname
                cell.labelDate.text = item.date
                return cell
            case let .more(text):
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: DetailMoreCell.self)
                cell.labelMore.text = text
                return cell
            }
        })
    }

    var imageViewBack: UIImageView!
    private var imageViewLocation: UIImageView!

    private var tableViewDetail: UITableView!

    private var viewMap: NMFNaverMapView!
    private var marker: NMFMarker!

    private var labelTitle: UILabel!
    private var labelRating: UILabel!
    private var labelRatingCount: UILabel!
    private var labelReview: UILabel!

    private var labelAddress: UILabel!
    private var labelNumber: UILabel!
    private var labelDate: UILabel!
    private var labelTime: UILabel!

    private var imageView1: UIImageView!
    private var imageView2: UIImageView!
    private var imageView3: UIImageView!
    private var imageView4: UIImageView!

    override func layout(parent: UIView) {
        layoutContent(parent: parent)
    }

    func bind(viewModel: ViewModelType) {
        bindNavigation(viewModel: viewModel)
        bindMap(viewModel: viewModel)
        bindHeader(viewModel: viewModel)
        bindList(viewModel: viewModel)
        bindPresentable(viewModel: viewModel)
    }
}

extension DetailViewController {
    func bindNavigation(viewModel: ViewModelType) {
        imageViewBack.whenTapped()
            .map { _ in .back }
            .bind(to: viewModel.actions)
            .disposed(by: disposeBag)
    }

    func bindMap(viewModel: ViewModelType) {
        viewModel.cameraPosition
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] coordinate in
                guard let self = self else { return }
                let target = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
                self.viewMap.mapView.moveCamera(NMFCameraUpdate(scrollTo: target))
                self.viewMap.mapView.locationOverlay.location = target
            })
            .disposed(by: disposeBag)

        Observable.from([
            imageViewLocation.whenTapped().map { _ in .location },
        ]).merge()
            .bind(to: viewModel.actions)
            .disposed(by: disposeBag)

        viewModel.authorizationStatus
            .subscribe(onNext: { [weak self] status in
                let position: NMFMyPositionMode = status == .denied ? .disabled : .normal
                self?.viewMap.mapView.positionMode = position
            })
            .disposed(by: disposeBag)

        viewModel.location
            .subscribe(onNext: { location in
                guard let coordinate = location.coordinate else { return }
                let target = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
                self.viewMap.mapView.moveCamera(NMFCameraUpdate(scrollTo: target))
                self.marker.position = target
            })
            .disposed(by: disposeBag)
    }

    func bindHeader(viewModel: ViewModelType) {
        viewModel.detail
            .subscribe(onNext: { [weak self] detail in
                guard let self = self else { return }
                self.labelTitle.text = detail.basicInfo?.placenamefull
                let sum = Double(detail.comment.scoresum)
                let count = Double(detail.comment.scorecnt)
                let avg = sum / max(count, 1)
                self.labelRating.text = String(format: "%.1f", avg)
                self.labelRatingCount.text = "(\(detail.comment.scorecnt))"
                self.labelReview.text = "리뷰 \(detail.blogReview?.blogrvwcnt ?? 0)"
                self.labelAddress.text = detail.basicInfo?.address?.newaddr?.newaddrfull
                self.labelNumber.text = detail.basicInfo?.phonenum
                self.labelDate.text = detail.basicInfo?.openHour?.periodList?
                    .first?.timeList?.first?.dayOfWeek ?? "-"
                self.labelTime.text = detail.basicInfo?.openHour?.periodList?
                    .first?.timeList?.first?.timeSE ?? "-"
                if let list = detail.photo?.photoList?.first?.list {
                    if let string = list[safe: 0]?.orgurl, let url = URL(string: string) {
                        self.imageView1.kf.setImage(with: url, options: [.transition(.fade(0.2))])
                    }
                    if let string = list[safe: 1]?.orgurl, let url = URL(string: string) {
                        self.imageView2.kf.setImage(with: url, options: [.transition(.fade(0.2))])
                    }
                    if let string = list[safe: 2]?.orgurl, let url = URL(string: string) {
                        self.imageView3.kf.setImage(with: url, options: [.transition(.fade(0.2))])
                    }
                    if let string = list[safe: 3]?.orgurl, let url = URL(string: string) {
                        self.imageView4.kf.setImage(with: url, options: [.transition(.fade(0.2))])
                    }
                }
                self.tableViewDetail.layoutTableHeaderView()
            })
            .disposed(by: disposeBag)
    }

    func bindList(viewModel: ViewModelType) {
        viewModel.items
            .bind(to: tableViewDetail.rx.items(dataSource: DetailViewController.dataSource))
            .disposed(by: disposeBag)
    }
}

extension DetailViewController {
    private func layoutContent(parent: UIView) {
        view.backgroundColor = .white

        tableViewDetail = UITableView().then { v in
            v.register(cellType: DetailMenuSeparatorCell.self)
            v.register(cellType: DetailMenuHeaderCell.self)
            v.register(cellType: DetailMenuItemCell.self)
            v.register(cellType: DetailCommentHeaderCell.self)
            v.register(cellType: DetailCommentItemCell.self)
            v.register(cellType: DetailReviewHeaderCell.self)
            v.register(cellType: DetailReviewItemCell.self)
            v.register(cellType: DetailMoreCell.self)
            v.contentInsetAdjustmentBehavior = .never
            v.contentInset = .init(top: 0, left: 0, bottom: bottomMargin, right: 0)
            v.separatorStyle = .none
        }.layout(parent) { m in
            m.edges.equalToSuperview()
        }

        let viewHeader = UIView()

        layoutHeader(parent: viewHeader)
        tableViewDetail.tableHeaderView = viewHeader
        tableViewDetail.layoutTableHeaderView()

        UIView().then { v in
            v.layer.applySketchShadow(color: .black, alpha: 0.3, y: 0, blur: 5)

            imageViewBack = UIImageView(image: #imageLiteral(resourceName: "ic_arrow_left_16")).then { v in
                v.contentMode = .center
                v.backgroundColor = .white
                v.layer.cornerRadius = 5
                v.layer.masksToBounds = true
            }.layout(v) { m in
                m.edges.equalToSuperview()
            }
        }.layout(parent) { m in
            m.top.equalTo(parent.safeAreaLayoutGuide).inset(4)
            m.left.equalToSuperview().inset(20)
            m.width.height.equalTo(36)
        }
    }

    private func layoutHeader(parent: UIView) {
        let viewMap = UIView().layout(parent) { m in
            m.top.left.right.equalToSuperview()
            m.height.equalTo(240)
        }
        let viewTitle = UIView().layout(parent) { m in
            m.top.equalTo(viewMap.snp.bottom).offset(32)
            m.left.right.equalToSuperview()
            m.height.equalTo(52)
        }
        let viewButton = UIView().layout(parent) { m in
            m.top.equalTo(viewTitle.snp.bottom).offset(16)
            m.left.right.equalToSuperview()
            m.height.equalTo(50)
        }
        let viewDescription = UIView().layout(parent) { m in
            m.top.equalTo(viewButton.snp.bottom).offset(32)
            m.left.right.equalToSuperview()
        }
        let viewImage = UIView().layout(parent) { m in
            m.top.equalTo(viewDescription.snp.bottom).offset(24)
            m.left.right.equalToSuperview().inset(20)
            m.bottom.equalToSuperview().inset(32)
            m.height.equalTo(285)
        }
        layoutMap(parent: viewMap)
        layoutTitle(parent: viewTitle)
        layoutButton(parent: viewButton)
        layoutDescription(parent: viewDescription)
        layoutImage(parent: viewImage)
    }

    private func layoutMap(parent: UIView) {
        viewMap = NMFNaverMapView().then { v in
            v.mapView.positionMode = .disabled
            v.showScaleBar = false
            v.showZoomControls = false
            v.showLocationButton = false
            v.mapView.contentInset = .init(top: 44, left: 0, bottom: 0, right: 0)
        }.layout(parent) { m in
            m.edges.equalToSuperview()
        }

        marker = NMFMarker().then { v in
            v.iconImage = NMFOverlayImage(image: #imageLiteral(resourceName: "ic_picker_red"))
            v.position = .init()
            v.mapView = viewMap.mapView
        }

        UIView().then { v in
            v.layer.applySketchShadow(color: .black, alpha: 0.3, y: 0, blur: 5)

            imageViewLocation = UIImageView(image: #imageLiteral(resourceName: "ic_location")).then { v in
                v.contentMode = .center
                v.backgroundColor = .white
                v.layer.cornerRadius = 5
                v.layer.masksToBounds = true
            }.layout(v) { m in
                m.edges.equalToSuperview()
            }
        }.layout(parent) { m in
            m.right.equalToSuperview().inset(20)
            m.bottom.equalToSuperview().inset(20)
            m.width.height.equalTo(36)
        }
    }

    private func layoutTitle(parent: UIView) {
        labelTitle = UILabel().then { v in
            v.font = .h2
            v.textColor = .rgb3C3C3C
        }.layout(parent) { m in
            m.top.equalToSuperview()
            m.centerX.equalToSuperview()
        }

        let viewInfo = UIView().layout(parent) { m in
            m.top.equalTo(labelTitle.snp.bottom).offset(10)
            m.centerX.equalToSuperview()
            m.bottom.equalToSuperview()
        }
        layoutInfo(parent: viewInfo)
    }

    private func layoutInfo(parent: UIView) {
        let imageViewStar = UIImageView(image: #imageLiteral(resourceName: "Ic_star_rating_17pt")).then { v in
            v.contentMode = .scaleAspectFit
        }.layout(parent) { m in
            m.top.left.equalToSuperview()
            m.bottom.equalToSuperview().inset(1)
        }

        labelRating = UILabel().then { v in
            v.font = .body2
            v.textColor = .rgbFF7375
        }.layout(parent) { m in
            m.left.equalTo(imageViewStar.snp.right)
            m.centerY.equalToSuperview()
        }
        labelRatingCount = UILabel().then { v in
            v.font = .body1
            v.textColor = .rgb8C8C8C
        }.layout(parent) { m in
            m.top.bottom.equalToSuperview()
            m.left.equalTo(labelRating.snp.right).offset(2)
        }
        labelReview = UILabel().then { v in
            v.font = .body1
            v.textColor = .rgb8C8C8C
        }.layout(parent) { m in
            m.top.bottom.right.equalToSuperview()
            m.left.equalTo(labelRatingCount.snp.right).offset(5)
        }
    }

    private func layoutButton(parent: UIView) {
        let viewPhone = UIView().layout(parent) { m in
            m.top.left.bottom.equalToSuperview()
        }
        let viewWay = UIView().layout(parent) { m in
            m.top.bottom.equalToSuperview()
            m.left.equalTo(viewPhone.snp.right)
            m.width.equalTo(viewPhone)
        }
        let viewShare = UIView().layout(parent) { m in
            m.top.bottom.equalToSuperview()
            m.left.equalTo(viewWay.snp.right)
            m.right.equalToSuperview()
            m.width.equalTo(viewWay)
        }

        UIView().then { v in
            v.backgroundColor = .rgbDCDCDC
        }.layout(parent) { m in
            m.top.equalTo(viewPhone).offset(4)
            m.bottom.equalTo(viewPhone)
            m.centerX.equalTo(viewPhone.snp.right)
            m.width.equalTo(1)
        }
        UIView().then { v in
            v.backgroundColor = .rgbDCDCDC
        }.layout(parent) { m in
            m.top.equalTo(viewWay).offset(4)
            m.bottom.equalTo(viewWay)
            m.centerX.equalTo(viewWay.snp.right)
            m.width.equalTo(1)
        }

        layoutButton(parent: viewPhone, title: "전화", image: #imageLiteral(resourceName: "ic_call"))
        layoutButton(parent: viewWay, title: "길 찾기", image: #imageLiteral(resourceName: "ic_wayfinding"))
        layoutButton(parent: viewShare, title: "공유", image: #imageLiteral(resourceName: "ic_share"))
    }

    private func layoutButton(parent: UIView, title: String, image: UIImage) {
        let imageView = UIImageView(image: image).then { v in
            v.contentMode = .center
        }.layout(parent) { m in
            m.top.equalToSuperview()
            m.centerX.equalToSuperview()
        }

        UILabel().then { v in
            v.font = .caption2
            v.text = title
            v.textColor = .rgb646464
        }.layout(parent) { m in
            m.top.equalTo(imageView.snp.bottom).offset(4)
            m.centerX.equalToSuperview()
            m.bottom.equalToSuperview()
        }
    }

    private func layoutDescription(parent: UIView) {
        UILabel().then { v in
            v.text = "주소"
            v.textColor = .rgb3C3C3C
            v.font = .body2
        }.layout(parent) { m in
            m.top.equalToSuperview()
            m.left.equalToSuperview().inset(20)
        }
        UILabel().then { v in
            v.text = "번호"
            v.textColor = .rgb3C3C3C
            v.font = .body2
        }.layout(parent) { m in
            m.top.equalToSuperview().inset(30)
            m.left.equalToSuperview().inset(20)
        }
        UILabel().then { v in
            v.text = "영업 시간"
            v.textColor = .rgb3C3C3C
            v.font = .body2
        }.layout(parent) { m in
            m.top.equalToSuperview().inset(60)
            m.left.equalToSuperview().inset(20)
        }

        labelAddress = UILabel().then { v in
            v.textColor = .rgb646464
            v.font = .body1
        }.layout(parent) { m in
            m.top.equalToSuperview()
            m.left.equalToSuperview().inset(88)
        }
        labelNumber = UILabel().then { v in
            v.textColor = .rgb646464
            v.font = .body1
        }.layout(parent) { m in
            m.top.equalToSuperview().inset(30)
            m.left.equalToSuperview().inset(88)
        }
        labelDate = UILabel().then { v in
            v.textColor = .rgb646464
            v.font = .body1
        }.layout(parent) { m in
            m.top.equalToSuperview().inset(60)
            m.left.equalToSuperview().inset(88)
        }
        labelTime = UILabel().then { v in
            v.textColor = .rgb646464
            v.font = .body1
        }.layout(parent) { m in
            m.top.equalToSuperview().inset(80)
            m.left.equalToSuperview().inset(88)
            m.bottom.equalToSuperview()
        }
    }

    private func layoutImage(parent: UIView) {
        imageView1 = UIImageView().then { v in
            v.contentMode = .scaleAspectFill
            v.backgroundColor = .rgbDCDCDC
            v.clipsToBounds = true
        }.layout(parent) { m in
            m.top.left.equalToSuperview()
        }
        imageView2 = UIImageView().then { v in
            v.contentMode = .scaleAspectFill
            v.backgroundColor = .rgbDCDCDC
            v.clipsToBounds = true
        }.layout(parent) { m in
            m.top.right.equalToSuperview()
            m.left.equalTo(imageView1.snp.right).offset(5)
            m.width.equalTo(imageView1)
        }
        imageView3 = UIImageView().then { v in
            v.contentMode = .scaleAspectFill
            v.backgroundColor = .rgbDCDCDC
            v.clipsToBounds = true
        }.layout(parent) { m in
            m.top.equalTo(imageView1.snp.bottom).offset(5)
            m.left.bottom.equalToSuperview()
            m.width.height.equalTo(imageView1)
        }
        imageView4 = UIImageView().then { v in
            v.contentMode = .scaleAspectFill
            v.backgroundColor = .rgbDCDCDC
            v.clipsToBounds = true
        }.layout(parent) { m in
            m.top.equalTo(imageView2.snp.bottom).offset(5)
            m.left.equalTo(imageView3.snp.right).offset(5)
            m.right.bottom.equalToSuperview()
            m.width.height.equalTo(imageView3)
        }
    }
}
