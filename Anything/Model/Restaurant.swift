//
//  Restaurant.swift
//  Anything
//
//  Created by Soso on 2020/11/14.
//  Copyright © 2020 Soso. All rights reserved.
//

import Foundation

struct Restaurant: Decodable {
    let addressName: String
    let categoryGroupCode: String
    let categoryGroupName: String
    let categoryName: String
    let distance, id, phone, placeName: String
    let placeUrl: String
    let roadAddressName, x, y: String
}
