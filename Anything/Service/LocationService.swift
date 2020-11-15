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

protocol LocationServiceType {
    func requestLocation() -> Observable<CLLocation?>
}

class LocationService: BaseService, LocationServiceType {
    var locationManager: CLLocationManager

    override init(provider: ServiceProviderType) {
        let locationManager = CLLocationManager()
        self.locationManager = locationManager

        super.init(provider: provider)

        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() -> Observable<CLLocation?> {
        let locationManager = self.locationManager
        return locationManager.rx.location
            .takeUntil(.inclusive, predicate: { $0 != nil })
            .do(onSubscribe: {
                locationManager.startUpdatingLocation()
            }, onDispose: {
                locationManager.stopUpdatingLocation()
            })
    }
}
