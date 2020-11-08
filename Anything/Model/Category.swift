//
//  Category.swift
//  Anything
//
//  Created by Soso on 2020/11/08.
//  Copyright © 2020 Soso. All rights reserved.
//

import Foundation

enum Category: CaseIterable {
    case 한식, 양식, 중식, 분식, 일식, 그외

    var icon: String {
        switch self {
        case .한식: return "🍚"
        case .양식: return "🍕"
        case .중식: return "🍕"
        case .분식: return "🍜"
        case .일식: return "🍣"
        case .그외: return "🍛"
        }
    }

    var name: String {
        switch self {
        case .한식: return "한식"
        case .양식: return "양식"
        case .중식: return "중식"
        case .분식: return "분식"
        case .일식: return "일식"
        case .그외: return "그외"
        }
    }
}
