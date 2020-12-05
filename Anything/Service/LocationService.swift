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
typealias AuthorizationStatus = CLAuthorizationStatus

protocol LocationServiceType {
    func requestCoordinate() -> Observable<Coordinate?>
    func requestName(coordinate: Coordinate) -> Observable<String>
    func requestAuthorizationStatus() -> Observable<CLAuthorizationEvent>
}

class LocationService: BaseService, LocationServiceType {
    private let locationManager: CLLocationManager
    private let geocoder: CLGeocoder

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

            self.geocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "ko_KR")) { placemarks, error in
                if let error = error {
                    log.error(error, file: #file, function: #function, line: #line)
                }
                if let name = placemarks?.first?.name {
                    emitter.onNext(name)
                }
                emitter.onCompleted()
            }

            return Disposables.create()
        }
    }

    func requestAuthorizationStatus() -> Observable<CLAuthorizationEvent> {
        return locationManager.rx.didChangeAuthorization
            .startWith(CLAuthorizationEvent(manager: locationManager, status: locationManager.authorizationStatus))
            .asObservable()
    }
}
