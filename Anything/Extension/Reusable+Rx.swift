//
//  Reusable+Rx.swift
//  d.code
//
//  Created by iamchiwon on 07/01/2019.
//  Copyright © 2019 n.code. All rights reserved.
//

import Reusable
import RxSwift
import UIKit

extension Reactive where Base: UITableView {
    public func items<S: Sequence, T: UITableViewCell, O: ObservableType>(cellType: T.Type)
        -> (_ source: O)
        -> (_ configureCell: @escaping (Int, S.Iterator.Element, T) -> Void)
        -> Disposable
        where O.Element == S, T: Reusable {
        return items(cellIdentifier: T.reuseIdentifier, cellType: cellType)
    }
}

extension Reactive where Base: UICollectionView {
    public func items<S: Sequence, T: UICollectionViewCell, O: ObservableType>(cellType: T.Type)
        -> (_ source: O)
        -> (_ configureCell: @escaping (Int, S.Iterator.Element, T) -> Void)
        -> Disposable
        where O.Element == S, T: Reusable {
            return items(cellIdentifier: T.reuseIdentifier, cellType: cellType)
    }
}
