//
//  Coordination.swift
//  20230227-EkambaramEswaran-Chase
//
//  Created by Ekambaram E on 2/27/23.
//

import Foundation
import CoreLocation

protocol CoreLocationManagerProtocol {
    func fetchLatLonBySearch(cityName: String, completion: @escaping (Double?, Double?) -> ())
}

class CoreLocationManager: CoreLocationManagerProtocol {
   
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
