
import Alamofire
import Foundation

final class DataService {
    func fetchData(query: String, completion: @escaping(Result<BookResponseDTO, Error>)->Void) {
        let url = "https://dapi.kakao.com/v3/search/book"
        let parameters: Parameters = [
            "query": query
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK \(Secrets.apiKey)"
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .responseDecodable(of: BookResponseDTO.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        
    }
}
