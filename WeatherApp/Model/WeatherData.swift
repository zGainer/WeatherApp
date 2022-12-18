//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Eugene on 13.12.22.
//

// Описание API:
// https://openweathermap.org/current

struct WeatherData: Decodable {
    let list: [List]
    let city: City
    
    func getWeatherModel(day: Int) -> WeatherModel {
        WeatherModel(name: city.name,
                     temp: list[day].main.temp,
                     feelsLike: list[day].main.feels_like,
                     humidity: list[day].main.humidity,
                     wind: list[day].wind.speed,
                     windGust: list[day].wind.gust ?? list[day].wind.speed,
                     iconID: list[day].weather[0].icon,
                     description: list[day].weather[0].description,
                     dateString: list[day].dt_txt)
    }
}

struct List: Decodable {
    let main: Main
    let wind: Wind
    let weather: [Weather]
    let dt_txt: String
}

struct City: Decodable {
    let name: String
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
