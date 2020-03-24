//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    var weatherManager=WeatherManager()
    let locationManager=CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        locationManager.delegate=self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.setDelegate(d: self)
        searchTextField.delegate=self
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    
}




//MARK: - UITextFieldDelegate


extension WeatherViewController:UITextFieldDelegate{
    
    
    @IBAction func searchPressed(_ sender: UIButton) {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true;
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text=="" {
            searchTextField.placeholder="type something"
            return false
        }else{
            return true
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city=searchTextField.text{
            
            weatherManager.fetchWeather(city: city)
        }
        
        
        searchTextField.text=""
    }
}



//MARK: - WeatherManagerDelegate


extension WeatherViewController:WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager:WeatherManager,weather:WeatherModel){
        DispatchQueue.main.async {
            print(weather.temprature)
            self.temperatureLabel.text=weather.tempratureString
            self.conditionImageView.image=UIImage(systemName: weather.conditionName)
            self.cityLabel.text=weather.city
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}






//MARK: - CLLocationManagerDelegate

extension WeatherViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if let location=locations.last{
            let lat=location.coordinate.latitude
            let long=location.coordinate.longitude
            weatherManager.fetchWeather(lat: lat, long: long)
            
        }
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

