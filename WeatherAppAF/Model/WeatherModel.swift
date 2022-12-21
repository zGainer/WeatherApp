//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Eugene on 13.12.22.
//

struct WeatherModel {
    let temp: Double
    let feelsLike: Double
    let humidity: Int
    let wind: Double
    let windGust: Double
    let iconID: String
    let description: String
    
    static func getModel(from value: Any) -> WeatherModel? {
        guard let forecast = value as? [String: Any] else { return nil }

        guard let main = forecast["main"] as? [String: Any] else { return nil }
        let weatherMain = Main(mainData: main)

        guard let wind = forecast["wind"] as? [String: Any] else { return nil }
        let weatherWind = Wind(windData: wind)

        guard let weather = forecast["weather"] as? [[String: Any]] else { return nil }
        let weatherWeather = Weather(weatherData: weather.first!)

        return WeatherModel(temp: weatherMain.temp,
                            feelsLike: weatherMain.feelsLike,
                            humidity: weatherMain.humidity,
                            wind: weatherWind.speed,
                            windGust: weatherWind.gust ?? weatherWind.speed,
                            iconID: weatherWeather.icon,
                            description: weatherWeather.description)
    }
}
