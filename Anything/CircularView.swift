//
//  CircularView.swift
//  Anything
//
//  Created by Soso on 2020/10/24.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit

class CircularView: UIView {
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
        let radius = bounds.width / 2 + 5

        let borderWidth: CGFloat = 10
        let clipWidth: CGFloat = 38
        let inset = midX - clipWidth

        let pathSmallOval = UIBezierPath(ovalIn: bounds.insetBy(dx: inset, dy: inset))
        let pathForeground = UIBezierPath(ovalIn: bounds.insetBy(dx: borderWidth, dy: borderWidth))
        let pathBackground = UIBezierPath(ovalIn: bounds)

        print(cos(30.0))

        guard let context = UIGraphicsGetCurrentContext() else { return }

        pathBackground.append(pathForeground.reversing())
        UIColor.white.withAlphaComponent(0.4).setFill()
        pathBackground.fill()

        pathForeground.append(pathSmallOval.reversing())
        UIColor.white.withAlphaComponent(0.04).setFill()
        pathForeground.fill()

        context.saveGState()
        context.setBlendMode(.destinationOut)

        let numberOfSlice = 6

        for angle in stride(from: -90, to: 270, by: 360 / numberOfSlice) {
            let angle = CGFloat(angle) * .pi / 180
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)

            let pathClip = UIBezierPath()
            pathClip.move(to: center)
            pathClip.addLine(to: .init(x: x, y: y))
            pathClip.close()
            pathClip.lineWidth = 14

            UIColor.white.setStroke()
            pathClip.stroke()
        }

        context.restoreGState()

        UIColor.white.setFill()
        pathSmallOval.fill()
    }

    private func angle(angle: CGFloat) -> CGFloat {
        return angle * CGFloat.pi / 180
    }
}
