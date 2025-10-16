//
//  NetworkService.swift
//  HabitTracker
//
//  Created by Shameem on 22/9/25.
//
import Foundation
import Combine

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
    case unknown
}

typealias CompletionHandler<T: Decodable> = (Result<T, NetworkError>) -> Void

protocol NetwoserkServiceProtocol {
    static func fetchData<T: Decodable>(request: BaseRouter, completion: @escaping CompletionHandler<T>)
}

final class NetworkService: NetwoserkServiceProtocol{
    
    private init() {}
    
    static func fetchData<T: Decodable>(request: BaseRouter, completion: @escaping CompletionHandler<T>) {
        do{
            let request = try request.asURLRequest()
            print("request is \(request.url?.absoluteString ?? "")")
            print("request headers is \(request.allHTTPHeaderFields ?? [:])")
            print("request body is \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "")")
            let task = URLSession.shared.dataTask(with: request) { data, response, error  in
                if let _ = error {
                    completion(.failure(.requestFailed))
                    return
                }
                if let data = data{
                    do{
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        print("decoded data is \(decodedData)")
                        completion(.success(decodedData))
                    }catch{
                        completion(.failure(.decodingFailed))
                    }
                }else{
                    completion(.failure(.unknown))
                    
                }
            }
            task.resume()
        }catch{
            completion(.failure(.invalidURL))
            print("url decoding error \(error.localizedDescription)")
        }
    }
    
    private func refreshToken(){
        
    }

    
}
