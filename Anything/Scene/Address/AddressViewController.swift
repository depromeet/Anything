//
//  AddressViewController.swift
//  Anything
//
//  Created by Soso on 2020/11/27.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit

class AddressViewController: BaseViewController, View {
    typealias ViewModelType = AddressViewModel

    private var imageViewBack: UIImageView!

    private var textFieldInput: UITextField!
    private var labelCurrent: UILabel!
    private var labelMap: UILabel!

    private var tableViewAddress: UITableView!

    override func layout(parent: UIView) {
        layoutContent(parent: parent)
    }

    func bind(viewModel: ViewModelType) {
        bindNavigation(viewModel: viewModel)
        bindInput(viewModel: viewModel)
        bindTableView(viewModel: viewModel)
        bindPresentable(viewModel: viewModel)
    }
}

extension AddressViewController {
    func bindNavigation(viewModel: ViewModelType) {
        imageViewBack.whenTapped()
            .map { _ in .back }
            .bind(to: viewModel.actions)
            .disposed(by: disposeBag)
    }

    func bindInput(viewModel: ViewModelType) {
        textFieldInput.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(textFieldInput.rx.text.orEmpty)
            .map(AddressAction.input)
            .bind(to: viewModel.actions)
            .disposed(by: disposeBag)

        labelCurrent.whenTapped()
            .map { _ in .current }
            .bind(to: viewModel.actions)
            .disposed(by: disposeBag)
        labelMap.whenTapped()
            .map { _ in .map }
            .bind(to: viewModel.actions)
            .disposed(by: disposeBag)
    }
    
    func bindTableView(viewModel: ViewModelType) {
        viewModel.locationList
            .bind(to: tableViewAddress.rx.items(cellType: AddressCell.self)) { index, location, cell in
                cell.labelName.text = location.placeName
                cell.labelAddress.text = location.addressName
                cell.whenTapped()
                    .map { _ in .selectLocation(index) }
                    .bind(to: viewModel.actions)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}

extension AddressViewController {
    private func layoutContent(parent: UIView) {
        view.backgroundColor = 0x141414.color

        imageViewBack = UIImageView(image: #imageLiteral(resourceName: "ic_arrow_left_24")).then { v in
            v.contentMode = .center
        }
        let navigationBar = NavigationBar(
            title: "주소 설정",
            leftView: imageViewBack
        ).layout(parent) { m in
            m.top.equalTo(parent.safeAreaLayoutGuide)
            m.left.right.equalToSuperview()
            m.height.equalTo(44)
        }

        let viewHeader = UIView().layout(parent) { m in
            m.top.equalTo(navigationBar.snp.bottom)
            m.left.right.equalToSuperview()
            m.height.equalTo(190)
        }
        layoutHeader(parent: viewHeader)

        tableViewAddress = UITableView().then { v in
            v.register(cellType: AddressCell.self)
            v.keyboardDismissMode = .onDrag
            v.rowHeight = 80
            v.separatorStyle = .singleLine
            v.separatorColor = .rgb646464
            v.separatorInset = .zero
            v.backgroundColor = .rgb282828
            v.tableFooterView = .init()
        }.layout(parent) { m in
            m.top.equalTo(viewHeader.snp.bottom)
            m.left.right.bottom.equalToSuperview()
        }
    }

    private func layoutHeader(parent: UIView) {
        let viewInput = UIView().then { v in
            v.backgroundColor = .rgb282828
            v.layer.cornerRadius = 8
            v.layer.masksToBounds = true
        }.layout(parent) { m in
            m.top.equalToSuperview().inset(60)
            m.left.right.equalToSuperview().inset(20)
            m.height.equalTo(40)
        }
        layoutInput(parent: viewInput)

        labelCurrent = UILabel().then { v in
            v.font = .subtitle3
            v.text = "내 위치"
            v.textColor = .white
            v.textAlignment = .center
            v.backgroundColor = .clear
            v.layer.cornerRadius = 8
            v.layer.masksToBounds = true
            v.layer.borderColor = UIColor.rgbDCDCDC.cgColor
            v.layer.borderWidth = 1
        }
        labelMap = UILabel().then { v in
            v.font = .subtitle3
            v.text = "지도에서 선택"
            v.textColor = .white
            v.textAlignment = .center
            v.backgroundColor = .rgbFD4145
            v.layer.cornerRadius = 8
            v.layer.masksToBounds = true
        }
        UIStackView(
            arrangedSubviews: [labelCurrent, labelMap]
        ).then { v in
            v.axis = .horizontal
            v.distribution = .fillEqually
            v.alignment = .fill
            v.spacing = 8
        }.layout(parent) { m in
            m.top.equalTo(viewInput.snp.bottom).offset(12)
            m.left.right.equalToSuperview().inset(20)
            m.height.equalTo(40)
        }
    }

    private func layoutInput(parent: UIView) {
        textFieldInput = UITextField().then { v in
            v.font = .body1
            v.textColor = .white
            v.returnKeyType = .done
        }.layout(parent) { m in
            m.top.equalToSuperview().inset(12)
            m.left.equalToSuperview().inset(16)
            m.right.equalToSuperview().inset(44)
            m.bottom.equalToSuperview().inset(10)
        }

        UIImageView(image: #imageLiteral(resourceName: "ic_search_24")).layout(parent) { m in
            m.right.equalToSuperview().inset(10)
            m.centerY.equalToSuperview()
            m.width.height.equalTo(24)
        }
    }
}
