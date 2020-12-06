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
                    cell.imageViewProfile.kf.setImage(with: url)
                }
                cell.viewRating.rating = Double(item.point ?? 0)
                cell.labelName.text = item.username
                cell.labelDate.text = item.date
                cell.labelContent.text = item.contents
                cell.labelContent.setLineSpacing(lineSpacing: 5)
                return cell
            }
        })
    }

    private var imageViewBack: UIImageView!
    private var imageViewLocation: UIImageView!

    private var tableViewDetail: UITableView!

    private var viewMap: NMFNaverMapView!

    override func layout(parent: UIView) {
        layoutContent(parent: parent)
    }

    func bind(viewModel: ViewModelType) {
        bindNavigation(viewModel: viewModel)
        bindMap(viewModel: viewModel)
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
            rx.viewWillAppear.map { _ in .location },
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
            m.height.equalTo(300)
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
            v.showLocationButton = false
            v.mapView.contentInset = .init(top: 44, left: 0, bottom: 0, right: 0)
        }.layout(parent) { m in
            m.edges.equalToSuperview()
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
        let viewTitle = UILabel().then { v in
            v.font = .h2
            v.textColor = .rgb3C3C3C
            v.text = "요란한 부엌"
        }.layout(parent) { m in
            m.top.equalToSuperview()
            m.centerX.equalToSuperview()
        }

        let viewInfo = UIView().layout(parent) { m in
            m.top.equalTo(viewTitle.snp.bottom).offset(10)
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

        let labelRating = UILabel().then { v in
            v.text = "4"
            v.font = .body2
            v.textColor = .rgbFF7375
        }.layout(parent) { m in
            m.left.equalTo(imageViewStar.snp.right)
            m.centerY.equalToSuperview()
        }
        let labelRatingCount = UILabel().then { v in
            v.text = "(66)"
            v.font = .body1
            v.textColor = .rgb8C8C8C
        }.layout(parent) { m in
            m.top.bottom.equalToSuperview()
            m.left.equalTo(labelRating.snp.right).offset(2)
        }
        UILabel().then { v in
            v.text = "리뷰 293"
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

        UILabel().then { v in
            v.text = "서울 동작구 대림로 12"
            v.textColor = .rgb646464
            v.font = .body1
        }.layout(parent) { m in
            m.top.equalToSuperview()
            m.left.equalToSuperview().inset(88)
        }
        UILabel().then { v in
            v.text = "02-124-9533"
            v.textColor = .rgb646464
            v.font = .body1
        }.layout(parent) { m in
            m.top.equalToSuperview().inset(30)
            m.left.equalToSuperview().inset(88)
        }
        UILabel().then { v in
            v.text = "월~일"
            v.textColor = .rgb646464
            v.font = .body1
        }.layout(parent) { m in
            m.top.equalToSuperview().inset(60)
            m.left.equalToSuperview().inset(88)
        }
        UILabel().then { v in
            v.text = "10:00~22:00"
            v.textColor = .rgb646464
            v.font = .body1
        }.layout(parent) { m in
            m.top.equalToSuperview().inset(80)
            m.left.equalToSuperview().inset(88)
            m.bottom.equalToSuperview()
        }
    }

    private func layoutImage(parent: UIView) {
        let imageView1 = UIImageView().then { v in
            v.contentMode = .scaleAspectFill
            v.backgroundColor = .rgbDCDCDC
        }.layout(parent) { m in
            m.top.left.equalToSuperview()
        }
        let imageView2 = UIImageView().then { v in
            v.contentMode = .scaleAspectFill
            v.backgroundColor = .rgbDCDCDC
        }.layout(parent) { m in
            m.top.right.equalToSuperview()
            m.left.equalTo(imageView1.snp.right).offset(5)
            m.width.equalTo(imageView1)
        }
        let imageView3 = UIImageView().then { v in
            v.contentMode = .scaleAspectFill
            v.backgroundColor = .rgbDCDCDC
        }.layout(parent) { m in
            m.top.equalTo(imageView1.snp.bottom).offset(5)
            m.left.bottom.equalToSuperview()
            m.width.height.equalTo(imageView1)
        }
        UIImageView().then { v in
            v.contentMode = .scaleAspectFill
            v.backgroundColor = .rgbDCDCDC
        }.layout(parent) { m in
            m.top.equalTo(imageView2.snp.bottom).offset(5)
            m.left.equalTo(imageView3.snp.right).offset(5)
            m.right.bottom.equalToSuperview()
            m.width.height.equalTo(imageView3)
        }
    }
}
