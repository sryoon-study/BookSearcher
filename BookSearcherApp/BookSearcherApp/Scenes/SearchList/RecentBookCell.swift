
import UIKit

import Kingfisher
import ReactorKit
import SnapKit
import Then

final class RecentBookCell: UICollectionViewCell, ReactorKit.View {
    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
    }

    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        $0.textColor = .secondaryLabel
        $0.numberOfLines = 2
    }

    var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)

        thumbnailImageView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(reactor: RecentBookCellReactor) {
        reactor.state
            .map { $0.thumbnailURL }
            .subscribe(onNext: { [weak self] url in
                self?.thumbnailImageView.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.title }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
