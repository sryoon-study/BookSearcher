
import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class BookDetailViewController: BaseViewController<BookDetailReactor> {
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        $0.textColor = .label
    }

    private let authorLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .secondaryLabel
    }

    private let translatorLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .secondaryLabel
    }

    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    private let priceLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        $0.textColor = .label
    }

    private let contentsLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.textColor = .label
        $0.numberOfLines = 0
    }

    private let closeButton = UIButton(configuration: .closed)

    private let favoriteButton = UIButton(configuration: .favoriteAdd)

    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 20
    }

    init(reactor: BookDetailReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(titleLabel)
        view.addSubview(authorLabel)
        view.addSubview(translatorLabel)
        view.addSubview(thumbnailImageView)
        view.addSubview(priceLabel)
        view.addSubview(contentsLabel)

        buttonStackView.addArrangedSubview(closeButton)
        buttonStackView.addArrangedSubview(favoriteButton)
        view.addSubview(buttonStackView)

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
        }
        authorLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        translatorLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(authorLabel.snp.bottom).offset(10)
        }
        thumbnailImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(translatorLabel.snp.bottom).offset(10)
        }
        priceLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(10)
        }
        contentsLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }

    override func bind(reactor: BookDetailReactor) {
        let book = reactor.currentState.book

        // 고정값 바인딩
        titleLabel.text = book.title
        authorLabel.text = book.author
        translatorLabel.text = book.translator
        priceLabel.text = book.salePrice
        contentsLabel.text = book.contents
        thumbnailImageView.kf.setImage(with: book.thumbnailURL)

        // 변동값 바인딩
        reactor.state.map { $0.isFavorite }
            .distinctUntilChanged()
            .bind { [weak self] isFavorite in
                // 즐겨찾기 상태 여부에 따라 버튼 configuration 변경
                self?.favoriteButton.configuration = isFavorite ? .favoriteRemove : .favoriteAdd
            }
            .disposed(by: disposeBag)

        // 닫기 버튼 탭
        closeButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        // 즐겨찾기 버튼 탭
        favoriteButton.rx.tap
            .map { .toggleFavorite }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
