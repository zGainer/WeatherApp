//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Eugene on 13.12.22.
//

// Описание API:
// https://openweathermap.org/current

// В Лондоне, Сиднее нет gust

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let wind: Wind
    let weather: [Weather]
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
    let description: String
}
