//
//  WeatherModel.swift
//  Clima
//
//  Created by Muneeb Ur Rehman on 24/03/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation


struct WeatherModel{
    
    let conditionID:Int
    let city:String
    let temprature:Float
    
    var tempratureString:String{
        String(format:"%.1f",temprature)
    }
    var conditionName:String {
        switch conditionID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        default:
            return "cloud"
        }
    }
    
}
