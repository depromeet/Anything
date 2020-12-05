//
//  MapViewController.swift
//  Anything
//
//  Created by Soso on 2020/11/28.
//  Copyright © 2020 Soso. All rights reserved.
//

import NMapsMap
import RxSwift
import RxViewController
import UIKit

class MapViewController: BaseViewController, View {
    typealias ViewModelType = MapViewModel

    private var imageViewBack: UIImageView!
    private var imageViewLocation: UIImageView!

    private var viewMap: NMFNaverMapView!

    private var labelLocation: UILabel!
    private var labelSave: UILabel!

    override func layout(parent: UIView) {
        layoutContent(parent: parent)
    }

    func bind(viewModel: ViewModelType) {
        bindNavigation(viewModel: viewModel)
        bindMap(viewModel: viewModel)
        bindBottom(viewModel: viewModel)
        bindPresentable(viewModel: viewModel)
    }
}

extension MapViewController: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        let target = mapView.cameraPosition.target
        let coordinate = Coordinate(latitude: target.lat, longitude: target.lng)
        viewModel?.actions.accept(.setCoordinate(coordinate))
    }
}

extension MapViewController {
    func bindNavigation(viewModel: ViewModelType) {
        imageViewBack.whenTapped()
            .map { _ in .back }
            .bind(to: viewModel.actions)
            .disposed(by: disposeBag)
    }

    func bindMap(viewModel: ViewModelType) {
        viewModel.newCoordinate
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

    func bindBottom(viewModel: ViewModelType) {
        viewModel.titleText
            .bind(to: labelLocation.rx.text)
            .disposed(by: disposeBag)

        labelSave.whenTapped()
            .map { _ in .save }
            .bind(to: viewModel.actions)
            .disposed(by: disposeBag)
    }
}

extension MapViewController {
    private func layoutContent(parent: UIView) {
        view.backgroundColor = .black

        viewMap = NMFNaverMapView().then { v in
            v.mapView.positionMode = .disabled
            v.showScaleBar = false
            v.showLocationButton = false
            v.mapView.contentInset = .init(top: 44, left: 0, bottom: 0, right: 0)
            v.mapView.addCameraDelegate(delegate: self)
        }.layout(parent) { m in
            m.top.left.right.equalToSuperview()
        }

        UIImageView(image: #imageLiteral(resourceName: "ic_picker")).layout(parent) { m in
            m.centerX.equalTo(viewMap)
            m.bottom.equalTo(viewMap.snp.centerY).offset(22)
        }

        let viewBottom = UIView().then { v in
            v.backgroundColor = .clear
        }.layout(parent) { m in
            m.top.equalTo(viewMap.snp.bottom)
            m.left.right.equalToSuperview()
            m.bottom.equalTo(parent.safeAreaLayoutGuide)
        }
        layoutBottom(parent: viewBottom)

        UIView().then { v in
            v.layer.applySketchShadow(color: .black, alpha: 0.3, y: 0, blur: 5)

            imageViewBack = UIImageView(image: #imageLiteral(resourceName: "ic_arrow_left_20")).then { v in
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
            m.bottom.equalTo(viewMap).offset(-20)
            m.width.height.equalTo(36)
        }
    }

    private func layoutBottom(parent: UIView) {
        let imageViewIcon = UIImageView(image: #imageLiteral(resourceName: "ic_pin_24")).layout(parent) { m in
            m.top.equalToSuperview().inset(27)
            m.left.equalToSuperview().inset(20)
            m.width.height.equalTo(24)
        }

        labelLocation = UILabel().then { v in
            v.font = .subtitle3
            v.textColor = .rgbFFFFFF
        }.layout(parent) { m in
            m.left.equalTo(imageViewIcon.snp.right).offset(5)
            m.right.equalToSuperview().inset(20)
            m.centerY.equalTo(imageViewIcon)
        }

        labelSave = UILabel().then { v in
            v.font = .subtitle3
            v.text = "저장"
            v.textColor = .white
            v.textAlignment = .center
            v.backgroundColor = .rgbFD4145
            v.layer.cornerRadius = 8
            v.layer.masksToBounds = true
        }.layout(parent) { m in
            m.top.equalTo(imageViewIcon.snp.bottom).offset(20)
            m.left.right.equalToSuperview().inset(20)
            m.bottom.equalToSuperview().inset(16)
            m.height.equalTo(40)
        }
    }
}
