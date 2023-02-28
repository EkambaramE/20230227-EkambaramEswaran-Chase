//
//  DetailViewController.swift
//  20230227-EkambaramEswaran-Chase
//
//  Created by Ekambaram E on 2/27/23.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    var weatherUI: WeatherUI = WeatherUI.fromNib() ?? WeatherUI()
    var weatherViewModel: WeatherViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = weatherViewModel?.responseModel?.name
        self.view.addSubview(weatherUI)
        updateUI()
    }
    
    func updateUI() {
        
        if let url = weatherViewModel?.fetchImageURL() {
            weatherUI.imageView?.kf.setImage(with: url)
        } else {
            //
        }
        weatherUI.temp?.text = weatherViewModel?.fetchCelsius()
        weatherUI.feelsLikeLabel?.text = weatherViewModel?.fetchFeelsLike()
        weatherUI.humidityLabel?.text = weatherViewModel?.fetchHumidity()
    }
}
