//
//  DistanceViewController.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/16.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import PanModal
import RxCocoa
import RxSwift
import SwiftyColor
import UIKit

typealias PanModalViewController = UIViewController & PanModalPresentable

class DistanceViewController: BaseViewController {
    var distances: [Distance]
    var selectedDistance: Distance

    var tableView: UITableView!

    init(
        distances: [Distance],
        selectedDistance: Distance
    ) {
        self.distances = distances
        self.selectedDistance = selectedDistance

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layout(parent: UIView) {
        layoutContent(parent: parent)
    }
}

extension DistanceViewController {
    private func layoutContent(parent: UIView) {
        view.backgroundColor = .black

        tableView = ResizableTableView().then { v in
            v.register(cellType: DistanceCell.self)
            v.tableHeaderView = .init(frame: .init(x: 0, y: 0, width: 0, height: 8))
            v.tableFooterView = .init(frame: .zero)
            v.backgroundColor = .clear
            v.separatorStyle = .none
            v.rowHeight = 48
            v.bounces = false
        }.layout(parent) { m in
            m.top.equalToSuperview()
            m.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            m.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        Observable.just(distances)
            .bind(to: tableView.rx.items(cellType: DistanceCell.self)) { [weak self] _, distance, cell in
                cell.labelDistance.text = distance.distanceText
                cell.labelTitle.text = distance.titleText
                cell.setSelected(isSelected: distance == self?.selectedDistance)
            }
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

extension DistanceViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }

    var shortFormHeight: PanModalHeight {
        view.setNeedsLayout()
        view.layoutIfNeeded()
        return .contentHeight(tableView.intrinsicContentSize.height)
    }

    var longFormHeight: PanModalHeight {
        view.setNeedsLayout()
        view.layoutIfNeeded()
        return .contentHeight(tableView.intrinsicContentSize.height)
    }

    var panModalBackgroundColor: UIColor {
        return 0x323232.color ~ 50%
    }
}

extension Reactive where Base: DistanceViewController {
    var itemSelected: ControlEvent<IndexPath> {
        return base.tableView.rx.itemSelected
    }
}
