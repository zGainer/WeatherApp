//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Eugene on 14.12.22.
//

import Foundation

struct WeatherManager {
    
    private let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric"
    private let appId = "&appid=7f38adc0a11fd4af805a53931604b32e"
    
    var delegate: WeatherManagerDelegate?
    
    func performRequest(with cityName: String) {
        let urlString = "\(weatherURL)\(appId)&q=\(cityName)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                print(error)
                
                return
            }
            
            if let data {
                if let weather = self.parseJSON(data) {
                    delegate?.updateWeather(with: weather)
                }
            }
        }.resume()
    }
    
    private func parseJSON(_ weatherData: Data) -> WeatherModel? {
        do {
            let decodedData = try JSONDecoder().decode(WeatherData.self, from: weatherData)
            
            let weatherModel = WeatherModel(name: decodedData.name,
                                            temp: decodedData.main.temp,
                                            feelsLike: decodedData.main.feels_like,
                                            humidity: decodedData.main.humidity,
                                            wind: decodedData.wind.speed,
                                            windGust: decodedData.wind.gust ?? decodedData.wind.speed,
                                            description: decodedData.weather[0].description)
            
            return weatherModel
        } catch {
            print(error)

            return nil
        }
    }
}

protocol WeatherManagerDelegate {
    func updateWeather(with weather: WeatherModel)
}
