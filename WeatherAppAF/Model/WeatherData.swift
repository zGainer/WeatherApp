//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Eugene on 13.12.22.
//

// Описание API:
// https://openweathermap.org/current

struct Main {
    let temp: Double
    let feelsLike: Double
    let humidity: Int
    
    init(mainData: [String: Any]) {
        self.temp = mainData["temp"] as? Double ?? 0
        self.feelsLike = mainData["feels_like"] as? Double ?? 0
        self.humidity = mainData["humidity"] as? Int ?? 0
    }
}

struct Wind {
    let speed: Double
    let gust: Double?
    
    init(windData: [String: Any]) {
        self.speed = windData["speed"] as? Double ?? 0
        self.gust = windData["gust"] as? Double ?? self.speed
    }
}

struct Weather {
    let icon: String
    let description: String
    
    init(weatherData: [String: Any]) {
        self.icon = weatherData["icon"] as? String ?? ""
        self.description = weatherData["description"] as? String ?? ""
    }
}
