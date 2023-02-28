//
//  File.swift
//  20230227-EkambaramEswaran-Chase
//
//  Created by Ekambaram E on 2/27/23.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case invalidResponse
    case decodingError
    case invalidServerResponse
    case invalidURL
}

protocol NetworkManagerProtocol {
    func fetchAPIService<T: Codable>(_ url: URL, model: T.Type, completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkManager {
    
    func fetchAPIService<T: Codable>(_ url: URL, model: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        let request = URLRequest(url: url)
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 || httpResponse.statusCode == 201
            else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(model.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
