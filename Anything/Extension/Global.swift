//
//  Global.swift
//  Anything
//
//  Created by Soso on 2020/11/14.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit

let screenSize = UIScreen.main.bounds.size
let screenWidth = screenSize.width
let screenHeight = screenSize.height

let statusHeight: CGFloat = {
    guard let window = UIApplication.shared.windows.first else {
        return 0
    }
    return window.safeAreaInsets.top
}()

let menuBarHeight: CGFloat = 58
let tabBarHeight: CGFloat = 49

let bottomMargin: CGFloat = {
    guard let window = UIApplication.shared.windows.first else {
        return 0
    }
    return window.safeAreaInsets.bottom
}()

let thin1px: CGFloat = {
    1 / UIScreen.main.nativeScale
}()

let hasNotch: Bool = bottomMargin > 0
