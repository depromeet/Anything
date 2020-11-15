//
//  CircularView.swift
//  Anything
//
//  Created by Soso on 2020/10/24.
//  Copyright © 2020 Soso. All rights reserved.
//

import RxCocoa
import RxSwift
import SwiftyColor
import UIKit

class CircularView: UIView {
    var categories: [Category] = Category.allCases {
        didSet {
            currentIndex = 0
        }
    }

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

        let cornerRadius: CGFloat = 20
        let spacing: CGFloat = 14 + cornerRadius
        let numberOfSlices = categories.count
        let sliceAngle = 360 / numberOfSlices
        let start = -90
        let end = start + 360

        for (index, angle) in stride(from: start, to: end, by: sliceAngle).enumerated() {
            var image: UIImage
            var textColor: UIColor
            if index == currentIndex {
                0xFF7375.color.set()
                image = categories[index].iconSelected
                textColor = .white
            } else {
                0xFFFFFF.color.set()
                image = categories[index].iconNormal
                textColor = .rgb3C3C3C
            }

            let radiusControl: CGFloat = (spacing / 2) / sin((sliceAngle / 2).radians)
            let xControl = center.x + radiusControl * cos(angle.radians)
            let yControl = center.y + radiusControl * sin(angle.radians)
            let pointControl = CGPoint(x: xControl, y: yControl)

            let startAngle = angle.radians - (sliceAngle / 2).radians
            let endAngle = startAngle + sliceAngle.radians

            let radiusSlice: CGFloat = bounds.midY - radiusControl - cornerRadius / 2

            let pathSlice = UIBezierPath()
            pathSlice.move(to: pointControl)
            pathSlice.addArc(withCenter: pointControl, radius: radiusSlice, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            pathSlice.close()
            pathSlice.lineJoinStyle = .round
            pathSlice.lineWidth = cornerRadius
            pathSlice.stroke()
            pathSlice.fill()

            let radiusItem: CGFloat = radiusSlice / 5 * 3
            let xItem = pointControl.x + radiusItem * cos(angle.radians)
            let yItem = pointControl.y + radiusItem * sin(angle.radians)
            let pointItem = CGPoint(x: xItem, y: yItem)

            let xIcon = pointItem.x - image.size.width / 2
            let yIcon = pointItem.y - image.size.height / 2 - 10
            let pointIcon = CGPoint(x: xIcon, y: yIcon)
            image.draw(at: pointIcon)

            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: textColor,
                .font: UIFont.sdgothicneo(size: 16, weight: .bold) ?? .systemFont(ofSize: 16, weight: .bold),
            ]
            let text = categories[index].name
            let size = text.size(withAttributes: attributes)
            let xName = pointItem.x - size.width / 2
            let yName = pointItem.y + image.size.height / 2 - 10
            let pointName = CGPoint(x: xName, y: yName)
            text.draw(at: pointName, withAttributes: attributes)
        }
    }
}

extension Reactive where Base: CircularView {
    var categories: Binder<[Category]> {
        return Binder(base) { view, categories in
            view.categories = categories
        }
    }

    var currentIndex: Binder<Int> {
        return Binder(base) { view, currentIndex in
            view.currentIndex = currentIndex
        }
    }
}
