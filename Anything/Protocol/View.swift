//
//  View.swift
//  d.code
//
//  Created by Soso on 2020/09/09.
//  Copyright © 2020 n.code. All rights reserved.
//

import Foundation
import RxSwift
import WeakMapTable

private typealias AnyView = AnyObject
private enum MapTables {
    static let reactor = WeakMapTable<AnyView, Any>()
}

protocol View: class {
    associatedtype ViewModelType: BaseViewModel
    var disposeBag: DisposeBag { get set }
    var viewModel: ViewModelType? { get set }
    func bind(viewModel: ViewModelType)
}

extension View {
    var viewModel: ViewModelType? {
        get {
            return MapTables.reactor.value(forKey: self) as? ViewModelType
        }
        set {
            MapTables.reactor.setValue(newValue, forKey: self)
            disposeBag = DisposeBag()
            if let viewModel = newValue {
                bind(viewModel: viewModel)
            }
        }
    }
}

extension View where Self: BaseViewController {
    func bindPresentable(viewModel: ViewModelType) {
        viewModel.presentable
            .subscribe(onNext: { [weak self] presentable in
                guard let self = self else { return }
                switch presentable {
                case let .push(vc):
                    let navC = self.navigationController
                    navC?.pushViewController(vc, animated: true)
                case .pop:
                    self.navigationController?.popViewController(animated: true)
                case let .present(vc, completion):
                    self.present(vc, animated: true, completion: completion)
                case let .dismiss(completion):
                    self.dismiss(animated: true, completion: completion)
                }
            })
            .disposed(by: disposeBag)
    }
}