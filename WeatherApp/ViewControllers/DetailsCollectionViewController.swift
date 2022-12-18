//
//  LongForecastCollectionViewController.swift
//  WeatherApp
//
//  Created by Eugene on 17.12.22.
//

import UIKit

class DetailsCollectionViewController: UICollectionViewController {

    let itemsPerRow: CGFloat = 1
    let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    var weatherData: WeatherData!
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as! WeatherCell
        
        let weatherModel = weatherData.getWeatherModel(day: indexPath.item * 8)
        
        cell.dateLabel.text = weatherModel.dateString
        
        cell.temperatureLabel.text = String("\(weatherModel.temp)°")
        
        fetchForecastIcon(iconID: weatherModel.iconID, cell: cell)
        
        cell.detailsLabel.text = """
                                 Feels like: \(weatherModel.feelsLike)
                                 Humidity: \(weatherModel.humidity)
                                 Wind: \(weatherModel.wind)
                                 Wind gust: \(weatherModel.windGust)
                                 Description: \(weatherModel.description)
                                 """

        return cell
    }
}

// MARK: - Common

extension DetailsCollectionViewController {
    
    func fetchForecastIcon(iconID: String, cell: WeatherCell) {
        
        let imageURL = "\(Link.iconPrefix.rawValue)\(iconID)\(Link.iconPostfix.rawValue)"
        
        NetworkManager.shared.fetchImage(url: imageURL) { result in
            switch result {
            case .success(let image):
                cell.weatherImage.image = UIImage(data: image)
            case .failure(let error):
                print("Image: \(error)")
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DetailsCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingWidth = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: 260)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionInserts
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sectionInserts.left
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        sectionInserts.left
    }
}
