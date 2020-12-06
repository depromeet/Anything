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
    case search(String, Double?, Double?, Int?, Int, Int)
    case detail(String)
}

extension AnythingAPI: SugarTargetType {
    var baseURL: URL {
        switch self {
        case .search:
            let string = "https://dapi.kakao.com"
            return URL(string: string)!
        case .detail:
            let string = "https://place.map.kakao.com"
            return URL(string: string)!
        }
    }

    var route: Route {
        switch self {
        case .search:
            return .get("/v2/local/search/keyword.json")
        case let .detail(id):
            return .get("/main/v/\(id)")
        }
    }

    var parameters: Parameters? {
        switch self {
        case let .search(keyword, latitude, longitude, radius, page, size):
            var values: [String: Any] = [
                "query": keyword,
                "page": page,
                "size": size,
            ]
            if let latitude = latitude,
               let longitude = longitude,
               let radius = radius {
                values["x"] = longitude
                values["y"] = latitude
                values["radius"] = radius
            }
            return .init(encoding: URLEncoding.default, values: values)
        case .detail:
            return nil
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
