//
//  DetailSection.swift
//  Anything
//
//  Created by Soso on 2020/12/05.
//  Copyright © 2020 Soso. All rights reserved.
//

import RxDataSources

enum DetailSection {
    case menu([DetailSectionItem])
}

extension DetailSection: SectionModelType {
    var items: [DetailSectionItem] {
        switch self {
        case let .menu(items):
            return items
        }
    }

    init(original: DetailSection, items: [DetailSectionItem]) {
        switch original {
        case .menu:
            self = .menu(items)
        }
    }
}

enum DetailSectionItem {
    case menuHeader
    case menuItem(MenuList)
}
