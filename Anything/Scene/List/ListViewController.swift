//
//  ListViewController.swift
//  Anything
//
//  Created by Soso on 2020/11/29.
//  Copyright © 2020 Soso. All rights reserved.
//

import NMapsMap
import RxSwift
import UIKit

class ListViewController: BaseViewController, View {
    typealias ViewModelType = ListViewModel

    private var imageViewBack: UIImageView!
    private var labelAddress: UILabel!
    private var labelCategory: UILabel!
    private var labelDistance: UILabel!

    private var viewMap: NMFNaverMapView!

    private var tableViewLocation: UITableView!

    private var viewRandom: UIView!

    private var markers: [String: NMFMarker] = [:]

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

extension ListViewController {
    func bindNavigation(viewModel: ViewModelType) {
        imageViewBack.whenTapped()
            .map { _ in .back }
            .bind(to: viewModel.actions)
            .disposed(by: disposeBag)
    }

    func bindMap(viewModel: ViewModelType) {
        viewModel.coordinate
            .take(1)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] coordinate in
                guard let self = self else { return }
                let target = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
                self.viewMap.mapView.moveCamera(NMFCameraUpdate(scrollTo: target))
            })
            .disposed(by: disposeBag)
    }

    func bindList(viewModel: ViewModelType) {
        viewModel.addressText
            .bind(to: labelAddress.rx.text)
            .disposed(by: disposeBag)
        viewModel.categoryText
            .bind(to: labelCategory.rx.text)
            .disposed(by: disposeBag)
        viewModel.distanceText
            .bind(to: labelDistance.rx.text)
            .disposed(by: disposeBag)

        viewModel.cameraPosition
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] coordinate in
                guard let self = self else { return }
                let target = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
                self.viewMap.mapView.moveCamera(NMFCameraUpdate(scrollTo: target))
                self.viewMap.mapView.locationOverlay.location = target
            })
            .disposed(by: disposeBag)

        viewModel.locationList
            .do(onNext: { [weak self] list in
                guard let self = self else { return }
                list.suffix(15).forEach { e in
                    let location = e.location
                    guard self.markers[location.id] == nil else { return }
                    guard let latitude = Double(location.y), let longitude = Double(location.x) else { return }
                    let target = NMGLatLng(lat: latitude, lng: longitude)
                    let marker = NMFMarker()
                    marker.iconImage = NMFOverlayImage(image: #imageLiteral(resourceName: "ic_pin_solid_21"))
                    marker.position = target
                    marker.mapView = self.viewMap.mapView
                    self.markers[location.id] = marker
                }
            })
            .bind(to: tableViewLocation.rx.items(cellType: ListLocationCell.self)) { index, cellViewModel, cell in
                cell.viewModel = cellViewModel
                cell.labelKey.text = "\(index + 1)"
                cell.whenTapped()
                    .map { _ in .position(index) }
                    .bind(to: viewModel.actions)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)

        tableViewLocation.rx
            .willDisplayCell
            .withLatestFrom(viewModel.locationList) { $1[$0.1.row] }
            .subscribe(onNext: { viewModel in
                viewModel.actions.accept(.fetch)
            })
            .disposed(by: disposeBag)

        tableViewLocation.whenBottomReached()
            .map { _ in .loadMore }
            .bind(to: viewModel.actions)
            .disposed(by: disposeBag)
    }
}

extension ListViewController {
    private func layoutContent(parent: UIView) {
        view.backgroundColor = .white

        viewMap = NMFNaverMapView().then { v in
            v.mapView.positionMode = .disabled
            v.showLocationButton = true
            v.mapView.contentInset = .init(top: 44, left: 0, bottom: 0, right: 0)
        }.layout(parent) { m in
            m.top.left.right.equalToSuperview()
            m.height.equalTo(300)
        }

        let viewList = UIView().then { v in
            v.backgroundColor = .clear
        }.layout(parent) { m in
            m.top.equalTo(viewMap.snp.bottom)
            m.left.right.equalToSuperview()
            m.bottom.equalToSuperview()
        }
        layoutList(parent: viewList)

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

        viewRandom = UIView().then { v in
            v.layer.applySketchShadow(color: .rgbFD4145, alpha: 0.3, x: 5, y: 5, blur: 10)
            UILabel().then { v in
                v.font = .subtitle3
                v.text = "음식점도 골라주세요!"
                v.textColor = .rgbFFFFFF
                v.textAlignment = .center
                v.backgroundColor = .rgbFD4145
                v.layer.cornerRadius = 8
                v.layer.masksToBounds = true
            }.layout(v) { m in
                m.edges.equalToSuperview()
            }
        }.layout(parent) { m in
            m.left.right.equalToSuperview().inset(20)
            m.bottom.equalTo(parent.safeAreaLayoutGuide).inset(14)
            m.height.equalTo(48)
        }
    }

    private func layoutList(parent: UIView) {
        let viewHeader = UIView().layout(parent) { m in
            m.top.left.right.equalToSuperview()
        }
        layoutHeader(parent: viewHeader)

        tableViewLocation = UITableView().then { v in
            v.register(cellType: ListLocationCell.self)
            v.separatorStyle = .singleLine
            v.separatorInset = .zero
            v.separatorColor = .rgbF1F1F1
            v.backgroundColor = .clear
            v.rowHeight = 92
            v.estimatedRowHeight = 92
        }.layout(parent) { m in
            m.top.equalTo(viewHeader.snp.bottom)
            m.left.right.bottom.equalToSuperview()
        }
    }

    private func layoutHeader(parent: UIView) {
        labelAddress = PaddingLabel().then { v in
            v.edgeInsets = .init(top: 8, left: 10, bottom: 6, right: 10)
            v.font = .body1
            v.textColor = .rgbFF7375
            v.textAlignment = .center
            v.backgroundColor = .clear
            v.layer.cornerRadius = 8
            v.layer.masksToBounds = true
            v.layer.borderWidth = 1
            v.layer.borderColor = UIColor.rgbFF7375.cgColor
        }.layout(parent) { m in
            m.top.bottom.equalToSuperview().inset(16)
            m.left.equalToSuperview().inset(20)
        }
        labelCategory = PaddingLabel().then { v in
            v.edgeInsets = .init(top: 8, left: 10, bottom: 6, right: 10)
            v.font = .body1
            v.textColor = .rgbFF7375
            v.textAlignment = .center
            v.backgroundColor = .clear
            v.layer.cornerRadius = 8
            v.layer.masksToBounds = true
            v.layer.borderWidth = 1
            v.layer.borderColor = UIColor.rgbFF7375.cgColor
        }.layout(parent) { m in
            m.top.bottom.equalToSuperview().inset(16)
            m.left.equalTo(labelAddress.snp.right).offset(6)
        }
        labelDistance = PaddingLabel().then { v in
            v.edgeInsets = .init(top: 8, left: 10, bottom: 6, right: 10)
            v.font = .body1
            v.textColor = .rgbFF7375
            v.textAlignment = .center
            v.backgroundColor = .clear
            v.layer.cornerRadius = 8
            v.layer.masksToBounds = true
            v.layer.borderWidth = 1
            v.layer.borderColor = UIColor.rgbFF7375.cgColor
        }.layout(parent) { m in
            m.top.bottom.equalToSuperview().inset(16)
            m.left.equalTo(labelCategory.snp.right).offset(6)
        }

        UIView().then { v in
            v.backgroundColor = .rgbF1F1F1
        }.layout(parent) { m in
            m.left.right.bottom.equalToSuperview()
            m.height.equalTo(1)
        }
    }
}
