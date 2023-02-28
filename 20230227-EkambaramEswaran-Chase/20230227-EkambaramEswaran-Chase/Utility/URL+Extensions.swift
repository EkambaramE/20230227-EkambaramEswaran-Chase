//
//  URL+Extensions.swift
//  20230227-EkambaramEswaran-Chase
//
//  Created by Ekambaram E on 2/27/23.
//

import Foundation

extension URL {
    
    static var baseURL: URL? {
        URL(string: kBaseURL)
    }
    
    static func weatherApiURL(lat: String, lon: String) -> URL? {
        return URL(string: "weather?lat=\(lat)&lon=\(lon)&appid=\(kAppId)", relativeTo: Self.baseURL)
    }
}
