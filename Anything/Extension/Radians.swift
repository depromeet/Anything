//
//  Radians.swift
//  Anything
//
//  Created by Soso on 2020/11/08.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit

extension Int {
    var radians: CGFloat {
        return CGFloat(self) * .pi / 180
    }
}

extension CGFloat {
    var radians: CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
