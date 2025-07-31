
import UIKit

import Kingfisher
import SnapKit
import Then

final class SearchedBookCell: UICollectionViewCell {
    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
    }

    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .label
        $0.numberOfLines = 2
    }

    private let authorLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.textColor = .secondaryLabel
    }

    private let priceLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .label
    }

    private let titleRow = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleRow.addArrangedSubview(titleLabel)
        titleRow.addArrangedSubview(authorLabel)

        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleRow)
        contentView.addSubview(priceLabel)

        thumbnailImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(59)
        }

        titleRow.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
        }

        priceLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, author: String, salePrice: String, thumbnailURL: URL) {
        titleLabel.text = title
        authorLabel.text = author
        priceLabel.text = salePrice
        thumbnailImageView.kf.setImage(with: thumbnailURL)
    }
}
