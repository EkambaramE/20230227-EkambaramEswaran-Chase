//
//  Utility.swift
//  20230227-EkambaramEswaran-Chase
//
//  Created by Ekambaram E on 2/27/23.
//

import Foundation

class Utility {
    
    static func fetchCelsius(k: Double) -> String {
        return String(Int(k - 273.15))
    }
    
    
    static func saveLastSearchResult(array: [String]) {
        let defaults = UserDefaults.standard
        defaults.set(array, forKey: "SearchResultArray")
    }
    
    static func fetchLastSearchResult() -> [String] {
        let defaults = UserDefaults.standard
        let myarray = defaults.stringArray(forKey: "SearchResultArray") ?? [String]()
        return myarray
    }
}
