//
//  WeatherCustomUI.swift
//  20230227-EkambaramEswaran-Chase
//
//  Created by Ekambaram E on 2/28/23.
//

import Foundation
import SwiftUI
import Kingfisher

public struct WeatherCustomUI: View {
        
    var weatherViewModel: WeatherViewModel?

    var celsius: String {
        weatherViewModel?.fetchCelsius() ?? ""
    }
    
    var feelsLikeLabel: String {
        weatherViewModel?.fetchFeelsLike() ?? ""
    }
    
    var humidityLabel: String {
        weatherViewModel?.fetchHumidity() ?? ""
    }
    
    public var body: some View {
        VStack {
            Spacer()
            KFImage(weatherViewModel?.fetchImageURL()).frame(width: 100, height: 100, alignment: .center)
            Text(celsius)
                .font(.system(size: 44))
                .fontWeight(.bold)
            Text("")
            Text(feelsLikeLabel)
                .font(.system(size: 18))
                .fontWeight(.bold)
            Text("")
            Text(humidityLabel)
                .font(.system(size: 18))
                .fontWeight(.bold)
        }.frame(width: UIScreen.main.bounds.size.width, height: 400, alignment: .center)
    }
}
