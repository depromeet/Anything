//
//  UIFont+Custom.swift
//  Anything
//
//  Created by Soso on 2020/11/14.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit

extension UIFont {
    static var h1: UIFont? = sdgothicneo(size: 30, weight: .black)
    static var h2: UIFont? = sdgothicneo(size: 20, weight: .bold)
    static var subtitle1: UIFont? = sdgothicneo(size: 18, weight: .bold)
    static var subtitle2: UIFont? = sdgothicneo(size: 17, weight: .medium)
    static var subtitle3: UIFont? = sdgothicneo(size: 17, weight: .bold)
    static var body1: UIFont? = sdgothicneo(size: 15, weight: .regular)
    static var body2: UIFont? = sdgothicneo(size: 15, weight: .bold)
    static var caption1: UIFont? = sdgothicneo(size: 12, weight: .medium)
    static var caption2: UIFont? = sdgothicneo(size: 12, weight: .bold)

    static func sdgothicneo(size: CGFloat, weight: Weight) -> UIFont? {
        switch weight {
        case .thin:
            return UIFont(name: "AppleSDGothicNeo-Thin", size: size)
        case .ultraLight:
            return UIFont(name: "AppleSDGothicNeo-UltraLight", size: size)
        case .light:
            return UIFont(name: "AppleSDGothicNeo-Light", size: size)
        case .regular:
            return UIFont(name: "AppleSDGothicNeo-Regular", size: size)
        case .medium:
            return UIFont(name: "AppleSDGothicNeo-Medium", size: size)
        case .semibold:
            return UIFont(name: "AppleSDGothicNeo-SemiBold", size: size)
        case .bold:
            return UIFont(name: "AppleSDGothicNeo-Bold", size: size)
        case .heavy:
            return UIFont(name: "AppleSDGothicNeo-Heavy", size: size)
        case .black:
            return UIFont(name: "AppleSDGothicNeo-ExtraBold", size: size)
        default:
            return nil
        }
    }
}
