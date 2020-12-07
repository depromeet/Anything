//
//  ListLocationCell.swift
//  Anything
//
//  Created by Soso on 2020/12/01.
//  Copyright © 2020 Soso. All rights reserved.
//

import RxKingfisher
import UIKit

class ListLocationCell: BaseTableViewCell, View {
    typealias ViewModelType = ListLocationViewModel

    var labelTitle: UILabel!
    var labelRating: UILabel!
    var labelRatingCount: UILabel!
    var labelReview: UILabel!
    var labelAddress: UILabel!
    var imageViewLocation: UIImageView!

    override func layout(parent: UIView) {
        layoutContent(parent: parent)
    }

    func bind(viewModel: ViewModelType) {
        labelTitle.text = viewModel.titleText
        viewModel.ratingText
            .bind(to: labelRating.rx.text)
            .disposed(by: disposeBag)
        viewModel.ratingCountText
            .bind(to: labelRatingCount.rx.text)
            .disposed(by: disposeBag)
        viewModel.reviewText
            .bind(to: labelReview.rx.text)
            .disposed(by: disposeBag)
        labelAddress.text = viewModel.addressText
        viewModel.imageUrlString
            .compactMap(URL.init)
            .bind(to: imageViewLocation.kf.rx.image(options: [.transition(.fade(0.2))]))
            .disposed(by: disposeBag)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageViewLocation.image = nil
    }
}

extension ListLocationCell {
    private func layoutContent(parent: UIView) {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        let viewContent = UIView().then { v in
            v.backgroundColor = .clear
        }.layout(parent) { m in
            m.top.bottom.equalToSuperview()
            m.left.right.equalToSuperview()
        }

        layoutContainer(parent: viewContent)
    }

    private func layoutContainer(parent: UIView) {
        let viewInfo = UIView().layout(parent) { m in
            m.left.equalToSuperview().inset(20)
            m.centerY.equalToSuperview()
        }
        imageViewLocation = UIImageView().then { v in
            v.contentMode = .scaleAspectFill
            v.backgroundColor = .rgbDCDCDC
            v.layer.cornerRadius = 8
            v.layer.masksToBounds = true
        }
        imageViewLocation.layout(parent) { m in
            m.top.bottom.equalToSuperview().inset(10)
            m.left.equalTo(viewInfo.snp.right).offset(10)
            m.right.equalToSuperview().inset(20)
            m.width.equalTo(imageViewLocation.snp.height)
        }

        layoutInfo(parent: viewInfo)
    }

    private func layoutInfo(parent: UIView) {
        let viewTop = UIView().layout(parent) { m in
            m.top.equalToSuperview()
            m.left.right.equalToSuperview()
        }
        let viewMiddle = UIView().layout(parent) { m in
            m.top.equalTo(viewTop.snp.bottom).offset(3)
            m.left.right.equalToSuperview()
        }
        let viewBottom = UIView().layout(parent) { m in
            m.top.equalTo(viewMiddle.snp.bottom).offset(3)
            m.left.right.equalToSuperview()
            m.bottom.equalToSuperview()
        }

        layoutTop(parent: viewTop)
        layoutMiddle(parent: viewMiddle)
        layoutBottom(parent: viewBottom)
    }

    private func layoutTop(parent: UIView) {
        labelTitle = UILabel().then { v in
            v.font = .subtitle3
            v.textColor = .rgb3C3C3C
        }.layout(parent) { m in
            m.top.left.right.bottom.equalToSuperview()
        }
    }

    private func layoutMiddle(parent: UIView) {
        let imageViewStar = UIImageView(image: #imageLiteral(resourceName: "Ic_star_rating_17pt")).then { v in
            v.contentMode = .scaleAspectFit
        }.layout(parent) { m in
            m.top.left.equalToSuperview()
            m.bottom.equalToSuperview().inset(1)
        }

        labelRating = UILabel().then { v in
            v.font = .body2
            v.textColor = .rgbFF7375
            v.setContentCompressionResistancePriority(.required, for: .horizontal)
        }.layout(parent) { m in
            m.left.equalTo(imageViewStar.snp.right)
            m.centerY.equalToSuperview()
        }
        labelRatingCount = UILabel().then { v in
            v.font = .body1
            v.textColor = .rgb8C8C8C
            v.setContentCompressionResistancePriority(.required, for: .horizontal)
        }.layout(parent) { m in
            m.top.bottom.equalToSuperview()
            m.left.equalTo(labelRating.snp.right).offset(2)
        }
        labelReview = UILabel().then { v in
            v.font = .body1
            v.textColor = .rgb8C8C8C
            v.setContentHuggingPriority(.init(0), for: .horizontal)
        }.layout(parent) { m in
            m.top.bottom.right.equalToSuperview()
            m.left.equalTo(labelRatingCount.snp.right).offset(5)
        }
    }

    private func layoutBottom(parent: UIView) {
        labelAddress = UILabel().then { v in
            v.font = .body1
            v.textColor = .rgb8C8C8C
        }.layout(parent) { m in
            m.edges.equalToSuperview()
        }
    }
}
