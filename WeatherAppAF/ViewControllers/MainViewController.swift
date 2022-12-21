//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Eugene on 13.12.22.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet var searchTF: UITextField!
    
    @IBOutlet var forecastLabel: UILabel!
    
    @IBOutlet weak var forecastImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTF.delegate = self
    }
}

// MARK: - Common

private extension MainViewController {
    func fetchWeatherData(for cityName: String) {
        
        NetworkManager.shared.fetchForecast(from: Link.weatherURL.rawValue,
                                            for: cityName) { [weak self] result in
            switch result {
            case .success(let weatherModel):
                
                self?.setForecastValues(with: weatherModel)
                
                self?.loadForecastIcon(iconID: weatherModel.iconID)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setForecastValues(with weather: WeatherModel) {
        
        DispatchQueue.main.async { [weak self] in
            self?.forecastLabel.text = """
                                       Temp: \(weather.temp)
                                       Feels like: \(weather.feelsLike)
                                       Humidity: \(weather.humidity)
                                       Wind: \(weather.wind)
                                       Wind gust: \(weather.windGust)
                                       Description: \(weather.description)
                                       """
        }
    }
    
    func loadForecastIcon(iconID: String) {
        
        let imageURL = "\(Link.iconPrefix.rawValue)\(iconID)\(Link.iconPostfix.rawValue)"
        
        NetworkManager.shared.fetchImage(from: imageURL) { [weak self] result in
            switch result {
            case .success(let image):
                self?.forecastImage.image = UIImage(data: image)
            case .failure(let error):
                print("Image: \(error)")
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension MainViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTF.endEditing(true)
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let cityName = searchTF.text?.trimmingCharacters(in: .whitespaces) {
            if !cityName.isEmpty {
                fetchWeatherData(for: cityName)
                
                searchTF.text = ""
            }
        }
    }
}
