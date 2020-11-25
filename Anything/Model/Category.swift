//
//  Category.swift
//  Anything
//
//  Created by Soso on 2020/11/08.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit

enum Category: String, CaseIterable {
    case 한식, 양식, 중식, 분식, 일식, 그외 = "아시아음식"

    var iconNormal: UIImage {
        switch self {
        case .한식: return #imageLiteral(resourceName: "ic_korea_bl_44pt")
        case .양식: return #imageLiteral(resourceName: "ic_western_bl_44pt")
        case .중식: return #imageLiteral(resourceName: "ic_china_bl_44pt")
        case .분식: return #imageLiteral(resourceName: "ic_schoolfood_bl_44pt")
        case .일식: return #imageLiteral(resourceName: "ic_japan_bl_44pt")
        case .그외: return #imageLiteral(resourceName: "ic_asia_bl_44pt")
        }
    }

    var iconSelected: UIImage {
        switch self {
        case .한식: return #imageLiteral(resourceName: "ic_korea_wh_44pt")
        case .양식: return #imageLiteral(resourceName: "ic_western_wh_44pt")
        case .중식: return #imageLiteral(resourceName: "ic_china_wh_44pt")
        case .분식: return #imageLiteral(resourceName: "ic_schoolfood_wh_44pt")
        case .일식: return #imageLiteral(resourceName: "ic_japan_wh_44pt")
        case .그외: return #imageLiteral(resourceName: "ic_asia_wh_44pt")
        }
    }
    
    var iconSmall: UIImage {
        switch self {
        case .한식: return #imageLiteral(resourceName: "ic_korea_bl_26pt")
        case .양식: return #imageLiteral(resourceName: "ic_western_bl_26pt")
        case .중식: return #imageLiteral(resourceName: "ic_china_bl_26pt")
        case .분식: return #imageLiteral(resourceName: "ic_schoolfood_bl_26pt")
        case .일식: return #imageLiteral(resourceName: "ic_japan_bl_26pt")
        case .그외: return #imageLiteral(resourceName: "ic_asia_bl_26pt")
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
