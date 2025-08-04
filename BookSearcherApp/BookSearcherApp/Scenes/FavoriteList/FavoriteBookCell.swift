
import UIKit

import Kingfisher
import SnapKit
import Then

final class FavoriteBookCell: UICollectionViewCell {
    // 썸네일
    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
    }

    // 제목
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .label
        $0.numberOfLines = 2
    }

    // 작가
    private let authorLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.textColor = .secondaryLabel
    }

    // 가격
    private let priceLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .label
    }

    // 타이틀,작가 스택뷰
    private let titleRow = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        // 뷰 주입
        titleRow.addArrangedSubview(titleLabel)
        titleRow.addArrangedSubview(authorLabel)

        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleRow)
        contentView.addSubview(priceLabel)

        // 오토 레이아웃
        thumbnailImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.height.equalTo(85)
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

    // 셀 생성
    func configure(title: String, author: String, salePrice: String, thumbnailURL: URL) {
        titleLabel.text = title
        authorLabel.text = author
        priceLabel.text = salePrice
        thumbnailImageView.kf.setImage(with: thumbnailURL)
    }
}
