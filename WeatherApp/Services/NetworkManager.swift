//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Eugene on 16.12.22.
//

import Foundation

enum Link: String {
    //    case weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric"
    case weatherFiveDaysURL = "https://api.openweathermap.org/data/2.5/forecast?units=metric"
    case appId = "&appid=7f38adc0a11fd4af805a53931604b32e"
    case iconPrefix = "https://openweathermap.org/img/wn/"
    case iconPostfix = "@2x.png"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager: Error {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetch<T: Decodable>(_ type: T.Type,
                             from url: String,
                             completion: @escaping(Result<T, NetworkError>) -> Void ) {
        
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                completion(.failure(.noData))
                
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                let type = try decoder.decode(T.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(type))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchImage(url: String, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            
            return
        }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                
                completion(.failure(.noData))
                
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
}
