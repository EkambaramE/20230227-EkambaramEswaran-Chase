//
//  Coordination.swift
//  20230227-EkambaramEswaran-Chase
//
//  Created by Ekambaram E on 2/27/23.
//

import Foundation
import CoreLocation


///CoreLocationManagerProtocol
protocol CoreLocationManagerProtocol {
    func fetchLatLonBySearch(cityName: String, completion: @escaping (Double?, Double?) -> ())
}


/// CoreLocationManager
class CoreLocationManager: CoreLocationManagerProtocol {
   
    
    /// Fetch the lat and lon based on location and zipCode
    /// - Parameters:
    ///   - cityName: cityName description
    ///   - completion: completion description
    func fetchLatLonBySearch(cityName: String, completion: @escaping (Double?, Double?) -> ()) {
        
        let geoLocation = CLGeocoder()
        geoLocation.geocodeAddressString(cityName) { placemarks, error in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                completion(nil, nil)
                return
            }
            completion(location.coordinate.latitude, location.coordinate.longitude)
        }
    }
}
