//
//  WeatherResponseModel.swift
//  20230227-EkambaramEswaran-Chase
//
//  Created by Ekambaram E on 2/27/23.
//

import Foundation

struct WeatherResponseModel: Codable {
    var coord: Coord
    var weather: [Weather]?
    var base: String
    var main: Main
    var wind: Wind
    var clouds: Clouds
    var sys: Sys
    var name: String
}

struct Sys: Codable {
    var country: String
    var sunrise: Double
    var sunset: Double
}

struct Clouds: Codable {
    var all: Int
}

struct Wind: Codable {
    var speed: Double
    var deg: Int
}

struct Main: Codable {
    var temp: Double
    var feels_like: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: Int
    var humidity: Int
}

struct Weather: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct Coord: Codable {
    var lon: Double?
    var lat: Double
}
