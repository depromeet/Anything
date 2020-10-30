//
//  CircularView.swift
//  Anything
//
//  Created by Soso on 2020/10/24.
//  Copyright © 2020 Soso. All rights reserved.
//

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

        let spacing: CGFloat = 14
        let numberOfSlice = 6
        let sliceAngle = 360 / numberOfSlice
        let start = 0 // -90 + sliceAngle / 2
        let end = start + 360

        for (index, angle) in stride(from: start, to: end, by: sliceAngle).enumerated() {
            let alpha: CGFloat = index == currentIndex ? 1 : 0.3
            let angle = angle.radians
            let radius: CGFloat = (spacing / 2) / sin((sliceAngle / 2).radians)
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            let point = CGPoint(x: x, y: y)

            let startAngle = angle - (sliceAngle / 2).radians
            let endAngle = startAngle + sliceAngle.radians
            let radiusLight: CGFloat = 100
            let radiusDark: CGFloat = 90

            UIColor.red.withAlphaComponent(alpha).setFill()

            let pathLight = UIBezierPath()
            pathLight.move(to: point)
            pathLight.addArc(withCenter: point, radius: radiusLight, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            pathLight.close()
            pathLight.fill()

            UIColor.orange.withAlphaComponent(alpha).setFill()

            let pathDark = UIBezierPath()
            pathDark.move(to: point)
            pathDark.addArc(withCenter: point, radius: radiusDark, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            pathDark.close()
            pathDark.fill()
        }
    }
}
