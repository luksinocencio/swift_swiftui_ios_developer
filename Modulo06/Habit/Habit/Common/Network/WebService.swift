import Foundation

// https://habitplus-api.tiagoaguiar.co/docs#/

enum WebService {
    enum Endpoint: String {
        case base = "https://habitplus-api.tiagoaguiar.co"
        case postUser = "/users"
    }
    
    enum NetworkError: Error {
        case badRequest
        case notFound
        case unauthorized
        case internalServerError
    }
    
    enum Result {
        case failure(NetworkError, Data?)
        case success(Data)
    }
    
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    private static func completeUrl(path: Endpoint) -> URLRequest? {
        guard let url = URL(string: "\(Endpoint.base.rawValue)\(path.rawValue)") else {
            return nil
        }
        
        return URLRequest(url: url)
    }
    
    private static func call<T: Encodable>(
        httpMethod: HttpMethod = .get,
        path: Endpoint,
        body: T,
        completion: @escaping (Result) -> Void
    ) {
        guard var urlRequest = completeUrl(path: path) else {
            print("badURL")
            completion(.failure(.internalServerError, nil))
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(body) else {
            print("badData")
            completion(.failure(.internalServerError, nil))
            return
        }
        
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("Erro de rede: \(error.localizedDescription)")
                completion(.failure(.internalServerError, nil))
                return
            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.internalServerError, nil))
                return
            }
            
            print("Status code: \(httpResponse.statusCode)")
            
            switch httpResponse.statusCode {
            case 200...299:
                completion(.success(data))
            case 400:
                completion(.failure(.badRequest, data))
            case 401:
                completion(.failure(.unauthorized, data))
            case 404:
                completion(.failure(.notFound, data))
            default:
                completion(.failure(.internalServerError, data))
            }
        }
        
        task.resume()
    }
    
    static func postUser(request: SignUpRequest, completion: @escaping (Result) -> Void) {
        call(httpMethod: .post, path: .postUser, body: request) { result in
            switch result {
            case .failure(let error, let data):
                let decoder = JSONDecoder()
                if let data {
                    if error == .badRequest {
                        let response = try? decoder.decode(SignUpResponse.self, from: data)
                        print(response?.detail)
                    }
                }
                break
            case .success(let data):
                print(String(data: data, encoding: .utf8))
                break
            }
        }
    }

    static func postUser(request: SignUpRequest) async -> Result {
        return await withCheckedContinuation { continuation in
            postUser(request: request) { result in
                continuation.resume(returning: result)
            }
        }
    }
}


//    private static func call<T: Codable>(
//        httpMethod: HttpMethod = .get,
//        path: Endpoint,
//        body: T,
//        completion: @escaping (Result) -> Void
//    ) {
//        guard var urlRequest = completeUrl(path: path) else {
//            print("badURL")
//            return
//        }
//
//        guard let jsonData = try? JSONEncoder().encode(body) else {
//            print("badData")
//            return
//        }
//
//        urlRequest.httpMethod = httpMethod.rawValue
//        urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.httpBody = jsonData
//
//        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//            guard let data = data, error == nil else {
//                completion(.failure(.internalServerError, nil))
//                return
//            }
//
//            if let r = response as? HTTPURLResponse {
//                print(r.statusCode)
//            }
//
//            if let r = response as? HTTPURLResponse {
//                switch r.statusCode {
//                case 400:
//                    completion(.failure(.badRequest, data))
//                    break
//                case 200...300:
//                    completion(.success(data))
//                    break
//                default:
//                    break
//                }
//            }
//        }
//
//        task.resume()
//    }
