//
//  BaseRouter.swift
//  HabitTracker
//
//  Created by Shameem on 22/9/25.
//
import Foundation

protocol BaseRouter{
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: [String: Any]? { get }
    var parameters: [String : String]? { get }
    
    
    var cachePolicy: URLRequest.CachePolicy? { get }
    
    
    func asURLRequest() throws -> URLRequest
    
}

extension BaseRouter {
    
    // setting cache policy as nil
    var cachePolicy: URLRequest.CachePolicy? { nil }
    
    // full url of request
    var url: URL? {
        guard let baseURL = URL(string: baseURL),
              var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            return nil
        }
        urlComponents.path += path
        urlComponents.queryItems = parameters?.sorted(by: { $0.0 < $1.0 }).map { URLQueryItem(name: $0, value: $1) }
        if urlComponents.path.isEmpty && urlComponents.queryItems?.count ?? 0 == 0 {
            return baseURL
        }
        
        return urlComponents.url
    }
    
    // default implement of URLRequest generation
    func asURLRequest() throws -> URLRequest {
        guard let url else { throw NetworkError.invalidURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        if let cachePolicy {
            urlRequest.cachePolicy = cachePolicy
        }
        
        headers?.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add body data for POST/PUT requests
        if let body = body {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
               
            } catch {
                throw NetworkError.requestFailed
            }
        }
        
        return urlRequest
    }
}
