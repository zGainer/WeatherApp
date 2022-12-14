//
//  ViewController.swift
//  WeatherApp
//
//  Created by Eugene on 13.12.22.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet var searchTF: UITextField!
    
    @IBOutlet var forecastLabel: UILabel!
    
    private var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        searchTF.delegate = self
    }
}

// MARK: - WeatherManagerDelegate

extension ViewController: WeatherManagerDelegate {
    
    func updateWeather(with weather: WeatherModel) {
        DispatchQueue.main.async {
            self.forecastLabel.text = """
                                      City: \(weather.name)
                                      Temp: \(weather.temp)
                                      Feels like: \(weather.feelsLike)
                                      Humidity: \(weather.humidity)
                                      Wind: \(weather.wind)
                                      Wind gust: \(weather.windGust)
                                      Description: \(weather.description)
                                      """
        }
    }
}

// MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTF.endEditing(true)
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // Если использовать автозаполнение то в конце добавляется пробел и url не срабатывает
        if let cityName = searchTF.text?.trimmingCharacters(in: .whitespaces) {
            
            if !cityName.isEmpty {
                weatherManager.performRequest(with: cityName)
                
                searchTF.text = ""
            }
        }
    }
}
