//
//  WeatherUI.swift
//  20230227-EkambaramEswaran-Chase
//
//  Created by Ekambaram E on 2/27/23.
//

import UIKit

public protocol NibInstantiatable {
    static func nibName() -> String
}

extension NibInstantiatable {
    static func nibName() -> String {
        return String(describing: self)
    }
}

extension NibInstantiatable where Self: UIView {
    static func fromNib() -> Self? {
        let bundle = Bundle(for: self)
        if let nib = bundle.loadNibNamed(nibName(), owner: self, options: nil), let self = nib.first as? Self {
            return self
        }
        return nil
    }
}

/// Created common UI for Weather view used in Home Screen and Details Screen
class WeatherUI: UIView, NibInstantiatable {
    
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var temp: UILabel?
    @IBOutlet weak var feelsLikeLabel: UILabel?
    @IBOutlet weak var humidityLabel: UILabel?
}
