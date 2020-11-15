//
//  Distance.swift
//  Anything
//
//  Created by Soso on 2020/11/15.
//  Copyright © 2020 Soso. All rights reserved.
//

import Foundation

enum Distance: Int, CaseIterable {
    case nearest = 500
    case near = 1000
    case medium = 1500
    case far = 2000

    var distanceText: String {
        switch self {
        case .nearest: return "500m"
        case .near: return "1km"
        case .medium: return "1.5km"
        case .far: return "2km"
        }
    }

    var titleText: String {
        switch self {
        case .nearest: return "도보 10분 이내"
        case .near: return "도보 20분 이내"
        case .medium: return "도보 30분 이내"
        case .far: return "도보 40분 이내"
        }
    }
}
