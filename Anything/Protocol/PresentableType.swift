//
//  PresentableType.swift
//  Anything
//
//  Created by Soso on 2020/11/14.
//  Copyright © 2020 Soso. All rights reserved.
//

import Foundation

enum PresentableType {
    case push(BaseViewController)
    case pop
    case present(BaseViewController, (() -> Void)? = nil)
    case dismiss((() -> Void)? = nil)
}

enum ProgressStatus {
    case show
    case hide
}
