//
//  WeatherViewModel.swift
//  20230227-EkambaramEswaran-Chase
//
//  Created by Ekambaram E on 2/27/23.
//

import Foundation
import CoreLocation
import SwiftUI


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
    
    
    /// Fetch location based service call
    /// - Parameters:
    ///   - lat: lat description
    ///   - lon: lon description
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
    
    
    /// Fetch the service call based on search
    /// - Parameter keySearch: keySearch description
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
    
    
    /// Fetch Image URL
    /// - Parameter isLocationBasedWeather: isLocationBasedWeather description
    /// - Returns: description
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
    
    
    /// Fetch Celsius
    /// - Parameter isLocationBasedWeather: isLocationBasedWeather description
    /// - Returns: description
    func fetchCelsius(isLocationBasedWeather: Bool = false) -> String {
        if isLocationBasedWeather {
            return Utility.fetchCelsius(k: currentLocationModel?.main.feels_like ?? 0.0) + "°C"
        } else {
            return Utility.fetchCelsius(k: responseModel?.main.feels_like ?? 0.0) + "°C"
        }
        
    }
    
    
    /// DescriptionFetch Feels like
    /// - Parameter isLocationBasedWeather: isLocationBasedWeather description
    /// - Returns: description
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
    
    
    /// Fetch the Humidity
    /// - Parameter isLocationBasedWeather: isLocationBasedWeather description
    /// - Returns: description
    func fetchHumidity(isLocationBasedWeather: Bool = false) -> String {
        if isLocationBasedWeather {
            let humidity = currentLocationModel?.main.humidity ?? 0
            return "Humidity: \(String(describing: humidity))%"
        } else {
            let humidity = responseModel?.main.humidity ?? 0
            return "Humidity: \(String(describing: humidity))%"
        }
    }
    
    func fetchWeatherCustomUI(isLocationBasedWeather: Bool = false) -> UIHostingController<WeatherCustomUI> {
        let child = UIHostingController(rootView: WeatherCustomUI(weatherViewModel: self))
        return child
    }
}
