//
//  Cubic.swift
//  Anything
//
//  Created by Soso on 2020/11/08.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit

typealias Easing = (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float
typealias BackEasing = (_ t: Float, _ b: Float, _ c: Float, _ d: Float, _ s: Float) -> Float
typealias ElasticEasing = (_ t: Float, _ b: Float, _ c: Float, _ d: Float, _ a: Float, _ p: Float) -> Float

struct Cubic {
    static var EaseIn: Easing = { (_t, b, c, d) -> Float in
        let t = _t / d
        return c * t * t * t + b
    }

    static var EaseOut: Easing = { (_t, b, c, d) -> Float in
        let t = _t / d - 1
        return c * (t * t * t + 1) + b
    }

    static var EaseInOut: Easing = { (_t, b, c, d) -> Float in
        var t = _t / (d / 2)
        if t < 1 {
            return c / 2 * t * t * t + b
        }
        t -= 2
        return c / 2 * (t * t * t + 2) + b
    }
}
