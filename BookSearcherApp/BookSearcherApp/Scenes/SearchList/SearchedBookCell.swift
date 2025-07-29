
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
    }

    private let authorLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.textColor = .secondaryLabel
    }

    private let priceLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .label
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(priceLabel)

        thumbnailImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(8)
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(8)
        }

        authorLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
        }

        priceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview().inset(8)
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, authors: [String], salePrice: Int, thumbnailURL: URL) {
        titleLabel.text = title
        authorLabel.text = StringFormatter.formatList(authors)
        priceLabel.text = StringFormatter.formatPrice(salePrice)
        thumbnailImageView.kf.setImage(with: thumbnailURL)
    }
}
