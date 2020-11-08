//
//  CircularView.swift
//  Anything
//
//  Created by Soso on 2020/10/24.
//  Copyright © 2020 Soso. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class CircularView: UIView {
    var currentIndex: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let midX = bounds.midX
        let midY = bounds.midY
        let center = CGPoint(x: midX, y: midY)

        let spacing: CGFloat = 35
        let numberOfSlice = 5
        let sliceAngle = 360 / numberOfSlice
        let start = -90
        let end = start + 360

        for (index, angle) in stride(from: start, to: end, by: sliceAngle).enumerated() {
            let angle = angle.radians
            let radius: CGFloat = (spacing / 2) / sin((sliceAngle / 2).radians)
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            let point = CGPoint(x: x, y: y)

            let startAngle = angle - (sliceAngle / 2).radians
            let endAngle = startAngle + sliceAngle.radians

            let radiusDark: CGFloat = 110

            if index == currentIndex {
                UIColor(hex: 0x3C3C3C).set()
            } else {
                UIColor(hex: 0x2D2D2D).set()
            }

            let pathDark = UIBezierPath()
            pathDark.move(to: point)
            pathDark.addArc(withCenter: point, radius: radiusDark, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            pathDark.close()
            pathDark.lineJoinStyle = .round
            pathDark.lineWidth = 25
            pathDark.stroke()
            pathDark.fill()
        }
    }
}

extension Reactive where Base: CircularView {
    var currentIndex: Binder<Int> {
        return Binder(base) { view, currentIndex in
            view.currentIndex = currentIndex
        }
    }
}
