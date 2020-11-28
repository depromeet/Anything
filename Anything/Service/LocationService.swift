//
//  LocationService.swift
//  Anything
//
//  Created by Soso on 2020/11/15.
//  Copyright © 2020 Soso. All rights reserved.
//

import CoreLocation
import Foundation
import RxCoreLocation
import RxSwift

typealias Coordinate = CLLocationCoordinate2D

protocol LocationServiceType {
    func requestCoordinate() -> Observable<Coordinate?>
    func requestName(coordinate: Coordinate) -> Observable<String>
}

class LocationService: BaseService, LocationServiceType {
    let locationManager: CLLocationManager
    let geocoder: CLGeocoder

    override init(provider: ServiceProviderType) {
        locationManager = CLLocationManager()
        geocoder = CLGeocoder()

        super.init(provider: provider)

        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestCoordinate() -> Observable<Coordinate?> {
        let locationManager = self.locationManager
        return locationManager.rx.location
            .takeUntil(.inclusive, predicate: { $0 != nil })
            .do(onSubscribe: {
                locationManager.startUpdatingLocation()
            }, onDispose: {
                locationManager.stopUpdatingLocation()
            })
            .map { $0?.coordinate }
    }

    func requestName(coordinate: Coordinate) -> Observable<String> {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        return Observable<String>.create { [weak self] emitter -> Disposable in
            guard let self = self else { return Disposables.create() }

            self.geocoder.reverseGeocodeLocation(location, preferredLocale: Locale.init(identifier: "ko_KR")) { placemarks, _ in
                if let name = placemarks?.first?.name {
                    emitter.onNext(name)
                }
                emitter.onCompleted()
            }

            return Disposables.create()
        }
    }
}
