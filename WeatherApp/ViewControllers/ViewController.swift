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
    
    @IBOutlet weak var forecastImage: UIImageView!

    @IBOutlet var moreButton: UIButton!
    
    var weatherData: WeatherData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTF.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsForecastVC = segue.destination as? DetailsCollectionViewController else { return }
        
        detailsForecastVC.weatherData = weatherData
    }
}

// MARK: - Common

extension ViewController {
    func fetchWeatherData(for cityName: String) {
        let urlString = "\(Link.weatherFiveDaysURL.rawValue)\(Link.appId.rawValue)&q=\(cityName)"
        
        NetworkManager.shared.fetch(WeatherData.self, from: urlString) { [weak self] result in
            switch result {
            case .success(let weather):
                
                self?.weatherData = weather
                
                let weatherModel = weather.getWeatherModel(day: 0)
                
                self?.setForecastValues(with: weatherModel)
                
                self?.loadForecastIcon(iconID: weatherModel.iconID)
                
                self?.moreButton.isHidden = false
            case .failure(let error):
                print(error)
                
                self?.moreButton.isHidden = true
            }
        }
    }
    
    func setForecastValues(with weather: WeatherModel) {
        
        DispatchQueue.main.async { [weak self] in
            self?.forecastLabel.text = """
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
    
    func loadForecastIcon(iconID: String) {
        
        let imageURL = "\(Link.iconPrefix.rawValue)\(iconID)\(Link.iconPostfix.rawValue)"
        
        NetworkManager.shared.fetchImage(url: imageURL) { [weak self] result in
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

extension ViewController: UITextFieldDelegate {
    
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
