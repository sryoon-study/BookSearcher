
import Alamofire
import Foundation

import RxSwift

class DataService: ReactiveCompatible {
    func searchBooks(query: String, page: Int, completion: @escaping (Result<BookResponseDTO, Error>) -> Void) {
        let url = "https://dapi.kakao.com/v3/search/book"
        let parameters: Parameters = [
            "query": query,
            "page": page,
        ]

        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK \(Secrets.apiKey)",
        ]

        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .responseDecodable(of: BookResponseDTO.self) { response in
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
}

extension Reactive where Base: DataService {
    func searchBooks(query: String, page: Int) -> Observable<BookResponseDTO> {
        return Observable.create { [base] observer in
            base.searchBooks(query: query, page: page) { result in
                switch result {
                case let .success(data):
                    observer.onNext(data)
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
