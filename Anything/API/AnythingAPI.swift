//
//  AnythingAPI.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/07/16.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Foundation
import Moya
import MoyaSugar

enum AnythingAPI {
    case search(String, Double?, Double?, Int?, Int)
}

extension AnythingAPI: SugarTargetType {
    var baseURL: URL {
        let string = "https://dapi.kakao.com/v2/local"
        return URL(string: string)!
    }

    var route: Route {
        switch self {
        case .search:
            return .get("/search/keyword.json")
        }
    }

    var parameters: Parameters? {
        switch self {
        case let .search(keyword, latitude, longitude, radius, page):
            var values: [String: Any] = [
                "query": keyword,
                "page": page,
                "size": 15,
            ]
            if let latitude = latitude,
               let longitude = longitude,
               let radius = radius {
                values["x"] = longitude
                values["y"] = latitude
                values["radius"] = radius
            }
            return .init(encoding: URLEncoding.default, values: values)
        }
    }

    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "KakaoAK 18fe637d900fc1957aa24e3997957074",
        ]
    }

    var sampleData: Data {
        return Data()
    }
}
