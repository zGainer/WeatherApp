//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Eugene on 16.12.22.
//

import Foundation
import Alamofire

enum Link: String {
    case weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric"
    case appId = "7f38adc0a11fd4af805a53931604b32e"
    case iconPrefix = "https://openweathermap.org/img/wn/"
    case iconPostfix = "@2x.png"
}

class NetworkManager: Error {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchForecast(from url: String,
                       for cityName: String,
                       completion: @escaping(Result<WeatherModel, AFError>) -> Void) {
        
        AF.request(url,
                   parameters: ["units": "metric",
                                "appid": Link.appId.rawValue,
                                "q": cityName])
        .validate()
        .responseJSON { dataResponse in
            switch dataResponse.result {
            case .success(let value):
                
                guard let weatherModel = WeatherModel.getModel(from: value) else { return }
                
                completion(.success(weatherModel))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchImage(from url: String, completion: @escaping(Result<Data, AFError>) -> Void ) {
        AF.request(url)
            .validate()
            .responseData { dataResponse in
                switch dataResponse.result {
                case .success(let imageData):
                    completion(.success(imageData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
