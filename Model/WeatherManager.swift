//
//  WeatherManager.swift
//  Clima
//
//  Created by Muneeb Ur Rehman on 22/03/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager,weather:WeatherModel)
    func didFailWithError(error:Error)
}

struct WeatherManager{
    
    var weatherURL:String="https://api.openweathermap.org/data/2.5/weather?"
    
    var delegate:WeatherManagerDelegate?
    
    func fetchWeather(city:String){
        let urlString=weatherURL+"q=\(city)&units=metric&APPID=6e0c02ed2c7af167a514a6213423e835"
        performRequest(with: urlString)
    }
    
    func fetchWeather(lat:Double,long:Double){
        let urlString=weatherURL+"lat=\(lat)&lon=\(long)&units=metric&APPID=6e0c02ed2c7af167a514a6213423e835"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString:String){
        if let url=URL(string: urlString){
            let urlSession=URLSession(configuration: .default)
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData=data{
                   let weatherData = self.parseJSON(safeData)
                    if let safeWeatherData=weatherData{
                        self.delegate?.didUpdateWeather(self,weather:safeWeatherData)
                    }
                }
                
            }
            
            
            task.resume()
            
        }
        
    }
    
    
    func parseJSON(_ weatherData:Data)->WeatherModel?{
        let jsonDecoder=JSONDecoder()
        do {
            let decodedData=try jsonDecoder.decode(WeatherData.self, from: weatherData)
            let id=decodedData.weather[0].id
            let name=decodedData.name
            let temp=decodedData.main.temp
            let weatherModel=WeatherModel(conditionID: id, city: name, temprature: temp)
            return weatherModel
            
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    
    mutating func setDelegate(d:WeatherManagerDelegate){
        delegate=d
    }
    
    
    
}

