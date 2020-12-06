//
//  DetailSection.swift
//  Anything
//
//  Created by Soso on 2020/12/05.
//  Copyright © 2020 Soso. All rights reserved.
//

import RxDataSources

enum DetailSection {
    case detail([DetailSectionItem])
}

extension DetailSection: SectionModelType {
    var items: [DetailSectionItem] {
        switch self {
        case let .detail(items):
            return items
        }
    }

    init(original: DetailSection, items: [DetailSectionItem]) {
        switch original {
        case .detail:
            self = .detail(items)
        }
    }
}

enum DetailSectionItem {
    case menuHeader
    case menuItem(MenuList)
    case menuSeparator
    case commentHeader(Comment)
    case commentItem(CommentList)
    case reviewHeader(BlogReview)
    case reviewItem(BlogReviewList)
}
