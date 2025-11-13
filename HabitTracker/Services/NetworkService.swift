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
    case authRequired
}

typealias CompletionHandler<T: Decodable> = (Result<T, NetworkError>) -> Void

protocol NetwoserkServiceProtocol {
    static func fetchData<T: Decodable>(request: BaseRouter, completion: @escaping CompletionHandler<T>)
}

final class NetworkService: NetwoserkServiceProtocol{
    
    private init() {}
    
    
    static func fetchData<T: Decodable>(request: BaseRouter, completion: @escaping CompletionHandler<T>) {
        fetchDataWithRetry(request: request, retryCount: 0, completion: completion)
    }
    
    private static func fetchDataWithRetry<T: Decodable>(
        request: BaseRouter,
        retryCount: Int,
        completion: @escaping CompletionHandler<T>
    ) {
        // Ensure network operation runs on background thread with proper QoS
        DispatchQueue.global(qos: .userInitiated).async {
            do{
                let urlRequest = try request.asURLRequest()
                
                let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                    // Check for network error
                    if let _ = error {
                        DispatchQueue.main.async {
                            completion(.failure(.requestFailed))
                        }
                        return
                    }
                    
                    // Check HTTP status code
                    if let httpResponse = response as? HTTPURLResponse {
                        
                        // Handle 401/403 with token refresh mechanism
                        if (httpResponse.statusCode == 401 || httpResponse.statusCode == 403) && retryCount < AppPrefix.maxRetries {
                            print("Received \(httpResponse.statusCode) error. Attempting token refresh... (Attempt \(retryCount + 1)/\(AppPrefix.maxRetries + 1))")
                            
                            // Call refresh token API on background queue
                            DispatchQueue.global(qos: .userInitiated).async {
                                refreshToken { success in
                                    if success {
                                        print("Token refreshed successfully. Retrying original request...")
                                        fetchDataWithRetry(
                                            request: request,
                                            retryCount: retryCount + 1,
                                            completion: completion
                                        )
                                    } else {
                                        print("Token refresh failed. Authentication required.")
                                        DispatchQueue.main.async {
                                            completion(.failure(.authRequired))
                                        }
                                    }
                                }
                            }
                            return
                        }
                        
                        // Handle other HTTP errors
                        if httpResponse.statusCode >= 400 {
                            print("HTTP Error: \(httpResponse.statusCode)")
                            DispatchQueue.main.async {
                                completion(.failure(.requestFailed))
                            }
                            return
                        }
                    }
                    
                    // Process successful response on background queue, then call completion on main
                    DispatchQueue.global(qos: .utility).async {
                        if let data = data {
                            do {
                                let decodedData = try JSONDecoder().decode(T.self, from: data)
                                print("decoded data is \(decodedData)")
                                DispatchQueue.main.async {
                                    completion(.success(decodedData))
                                }
                            } catch {
                                print("Decoding error: \(error.localizedDescription)")
                                DispatchQueue.main.async {
                                    completion(.failure(.decodingFailed))
                                }
                            }
                        } else {
                            print("No data received")
                            DispatchQueue.main.async {
                                completion(.failure(.unknown))
                            }
                        }
                    }
                }
                task.resume()
            } catch {
                print("URL request creation error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(.invalidURL))
                }
            }
        }
    }
    
    private static func refreshToken(completion: @escaping (Bool) -> Void) {
        // Get stored refresh token
        guard let refreshToken = AuthStorage.shared.getRefreshToken() else {
            print("No refresh token available")
            completion(false)
            return
        }
        
        print("refresh token is = \(refreshToken)")
        // Create refresh token request
        let refreshTokenRequest = RefreshTokenRouter.refreshToken(refreshToken: refreshToken)
        
        do {
            let urlRequest = try refreshTokenRequest.asURLRequest()
            print("Refreshing token with request: \(urlRequest.url?.absoluteString ?? "")")
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    print("Token refresh network error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("Token refresh HTTP Status: \(httpResponse.statusCode)")
                    
                    if httpResponse.statusCode == 200, let data = data {
                        do {
                            // Parse the new token response
                            let tokenResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                            
                            // Store new tokens
                            AuthStorage.shared.saveAuthData(response: tokenResponse)
                            print("Token refreshed successfully")
                            completion(true)
                        } catch {
                            print("Token refresh decoding error: \(error.localizedDescription)")
                            completion(false)
                        }
                    } else {
                        print("Token refresh failed with status: \(httpResponse.statusCode)")
                        // If refresh token is also invalid, clear stored tokens
                        if httpResponse.statusCode == 401 || httpResponse.statusCode == 403 {
                            AuthStorage.shared.clearAuthData()
                        }
                        completion(false)
                    }
                } else {
                    print("Invalid response from token refresh")
                    completion(false)
                }
            }
            task.resume()
        } catch {
            print("Token refresh request creation error: \(error.localizedDescription)")
            completion(false)
        }
    }

    
}
