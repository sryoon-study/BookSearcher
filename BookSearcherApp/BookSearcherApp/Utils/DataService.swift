
import Alamofire
import Foundation

final class DataService {
    func fetchData(query: String, completion: @escaping (Result<BookResponseDTO, Error>) -> Void) {
        let url = "https://dapi.kakao.com/v3/search/book"
        let parameters: Parameters = [
            "query": query,
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
