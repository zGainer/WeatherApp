//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Eugene on 13.12.22.
//

// Описание API:
// https://openweathermap.org/current

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let wind: Wind
    let weather: [Weather]
    
    func getWeatherModel() -> WeatherModel {
        WeatherModel(name: name,
                     temp: main.temp,
                     feelsLike: main.feels_like,
                     humidity: main.humidity,
                     wind: wind.speed,
                     windGust: wind.gust ?? wind.speed,
                     iconID: weather[0].icon,
                     description: weather[0].description)
    }
}

struct Main: Decodable {
    let temp: Double
    let feels_like: Double
    let humidity: Int
}

struct Wind: Decodable {
    let speed: Double
    let gust: Double?
}

struct Weather: Decodable {
    let icon: String
    let description: String
}


