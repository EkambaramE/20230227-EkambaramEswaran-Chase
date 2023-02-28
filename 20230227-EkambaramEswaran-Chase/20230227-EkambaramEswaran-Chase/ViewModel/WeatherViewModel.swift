//
//  WeatherViewModel.swift
//  20230227-EkambaramEswaran-Chase
//
//  Created by Ekambaram E on 2/27/23.
//

import Foundation
import CoreLocation


class WeatherViewModel {
    
    var recentSearches: [String]? = Utility.fetchLastSearchResult()
    var networkManager: NetworkManagerProtocol?
    var updateResponse: () -> () = {}
    var updateLocationResponse: () -> () = {}
    
    private(set) var responseModel: WeatherResponseModel? {
        didSet {
            self.updateResponse()
        }
    }
    
    private(set) var currentLocationModel: WeatherResponseModel? {
        didSet {
            self.updateLocationResponse()
        }
    }
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchLocationServiceCall(lat: String, lon: String) {
        if let url = URL.weatherApiURL(lat: lat, lon: lon) {
            self.networkManager?.fetchAPIService(url, model: WeatherResponseModel.self) { result in
                switch result {
                case.success(let response):
                    if let model = response as? WeatherResponseModel {
                        self.currentLocationModel = model
                    }
                case.failure(_):
                    self.currentLocationModel = nil
                }
            }
        }
        
    }
    
    func makeServiceCall(keySearch: String) {
        self.networkManager?.fetchWeatherInfo(keySearch: keySearch) { lat, lon in
            if let url = URL.weatherApiURL(lat: lat, lon: lon) {
                self.responseModel = nil
                self.networkManager?.fetchAPIService(url, model: WeatherResponseModel.self) { result in
                    switch result {
                    case.success(let response):
                        if let model = response as? WeatherResponseModel {
                            self.responseModel = model
                        }
                    case.failure(_):
                        self.responseModel = nil
                    }
                }
            }
        }
    }
    
    func fetchImageURL(isLocationBasedWeather: Bool = false) -> URL? {
        if isLocationBasedWeather {
            if let icon = currentLocationModel?.weather?[0].icon, let url = URL(string: String(format: "%@%@@2x.png", kImageBaseURL,  icon)) {
                return url
            }
        } else {
            if let icon = responseModel?.weather?[0].icon, let url = URL(string: String(format: "%@%@@2x.png", kImageBaseURL,  icon)) {
                return url
            }
        }
        return nil
    }
    
    func fetchCelsius(isLocationBasedWeather: Bool = false) -> String {
        if isLocationBasedWeather {
            return Utility.fetchCelsius(k: currentLocationModel?.main.feels_like ?? 0.0) + "°C"
        } else {
            return Utility.fetchCelsius(k: responseModel?.main.feels_like ?? 0.0) + "°C"
        }
        
    }
    
    func fetchFeelsLike(isLocationBasedWeather: Bool = false) -> String {
        if isLocationBasedWeather {
            let status = currentLocationModel?.weather?[0].main ?? ""
            let celsius = Utility.fetchCelsius(k: currentLocationModel?.main.feels_like ?? 0.0) + "°C"
            let feelsLike = String(describing: currentLocationModel?.weather?[0].description.capitalized ?? "")
            return "Feels like: \(celsius). \(feelsLike). \(status)."
        } else {
            let status = responseModel?.weather?[0].main ?? ""
            let celsius = Utility.fetchCelsius(k: responseModel?.main.feels_like ?? 0.0) + "°C"
            let feelsLike = String(describing: responseModel?.weather?[0].description.capitalized ?? "")
            return "Feels like: \(celsius). \(feelsLike). \(status)."
        }
    }
    
    func fetchHumidity(isLocationBasedWeather: Bool = false) -> String {
        if isLocationBasedWeather {
            let humidity = currentLocationModel?.main.humidity ?? 0
            return "Humidity: \(String(describing: humidity))%"
        } else {
            let humidity = responseModel?.main.humidity ?? 0
            return "Humidity: \(String(describing: humidity))%"
        }
    }
}
