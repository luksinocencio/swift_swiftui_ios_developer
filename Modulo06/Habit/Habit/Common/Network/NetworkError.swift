import Foundation

enum NetworkError: Error, Equatable, Sendable {
    case invalidURL
    case requestFailed
    case invalidResponse
    case unacceptableStatusCode(Int, message: String?)
    case decodingFailed
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "Endereço da requisição inválido."
        case .requestFailed:
            "Não foi possível conectar ao servidor. Verifique sua conexão."
        case .invalidResponse:
            "Resposta inesperada do servidor."
        case let .unacceptableStatusCode(code, message):
            if let message, !message.isEmpty {
                message
            } else if code == 401 {
                "Sua sessão expirou. Faça login novamente."
            } else {
                "O servidor retornou um erro (código \(code))."
            }
        case .decodingFailed:
            "Não foi possível ler a resposta do servidor."
        }
    }
}

extension NetworkError {
    static func serverMessage(from data: Data) -> String? {
        (try? JSONDecoder().decode(APIErrorBody.self, from: data))?.message
    }
}

private struct APIErrorBody: Decodable {
    let message: String?

    private enum CodingKeys: String, CodingKey {
        case detail
    }

    private struct DetailObject: Decodable {
        let message: String
    }

    private struct ValidationItem: Decodable {
        let msg: String
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let text = try? container.decode(String.self, forKey: .detail) {
            message = text
        } else if let object = try? container.decode(DetailObject.self, forKey: .detail) {
            message = object.message
        } else if let items = try? container.decode([ValidationItem].self, forKey: .detail) {
            message = items.first?.msg
        } else {
            message = nil
        }
    }
}
