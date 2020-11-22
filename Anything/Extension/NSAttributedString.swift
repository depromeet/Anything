//
//  NSAttributedString.swift
//  Anything
//
//  Created by Soso on 2020/11/22.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit

extension NSAttributedString {
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: attributedString.length))

        return attributedString
    }
}

extension UIButton {
    func underlineButton(text: String, fromAt: Int) {
        let titleString = NSMutableAttributedString(string: text)
        titleString.addAttribute(
            NSAttributedString.Key.underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: fromAt, length: text.count - fromAt)
        )
        titleString.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: titleColor(for: .normal) ?? UIColor.black,
            range: NSRange(location: 0, length: text.count)
        )
        setAttributedTitle(titleString, for: .normal)
    }
}

extension UILabel {
    func underline() {
        if let textString = text {
            let attributedString = NSMutableAttributedString(string: textString)
            let stringRange = NSRange(location: 0, length: textString.count)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: stringRange)
            attributedText = attributedString
        }
    }

    func strike() {
        if let textString = text {
            let attributed = NSMutableAttributedString(string: textString)
            let stringRange = NSRange(location: 0, length: textString.count)
            attributed.addAttribute(NSAttributedString.Key.baselineOffset, value: 0, range: stringRange)
            attributed.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: stringRange)
            attributedText = attributed
        }
    }

    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        guard let labelText = text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString: NSMutableAttributedString
        if let labelattributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: attributedString.length))

        attributedText = attributedString
    }
}
