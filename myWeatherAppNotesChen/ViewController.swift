//
//  ViewController.swift
//  myWeatherAppNotesChen
//
//  Created by ALVIN CHEN on 1/8/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var minTempOutlet: UILabel!
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    @IBOutlet weak var windDirection: UILabel!
    
    @IBOutlet weak var maxTempOutlet: UILabel!

    @IBOutlet weak var sunsetTimeOutlet: UILabel!

    
    @IBOutlet weak var labelOutlet: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeather()
        // Do any additional setup after loading the view.
    }
    func getWeather(){
        
        let session = URLSession.shared
        
        let weatherURL = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=44.24&lon=-88.32&units=imperial&appid=3fec9efc5efff4a92b78d3275faaa7c6")
        
        print("data")
        
        let dataTask = session.dataTask(with: weatherURL!) { [self] (data:Data?, response:URLResponse?, error:Error?) in
            if let e = error{
                print("\(e)")
            }
            
            else{
                
                if let d = data{
                    print("found data")
                    if let jsonObj = try? JSONSerialization.jsonObject(with: d, options: .allowFragments) as? NSDictionary{
                        print("\(jsonObj)")
                        
                       if let wind = jsonObj.value(forKey: "wind") as? NSDictionary{
                           if let speed = wind.value(forKey: "speed") as? NSNumber{
                               DispatchQueue.main.async{
                                   self.windSpeedLabel.text = "wind speed: \(speed)"
                               }
                           }
                           if let direction = wind.value(forKey: "deg") as? Double{
                               
                               var d = ""
                               
                               if (direction > 60 && direction < 120){
                                   d = "North"
                               }
                               
                               else if (direction > 150 && direction < 210){
                                   d = "West"
                               }
                               
                               else if (direction > 240 && direction < 300){
                                   d = "South"
                               }
                               
                               else if (direction >= 30 && direction <= 60){
                                   d = "Northeast"
                               }
                               
                               else if (direction >= 120 && direction <= 150){
                                   d = "Northwest"
                               }
                               else if (direction >= 210 && direction <= 240){
                                   d = "Southwest"
                               }
                               else if (direction >= 300 && direction <= 330){
                                   d = "Southeast"
                               }
                               else{
                                   d = "East"
                               }
                               
                               
                               DispatchQueue.main.async{

                                   print("d is \(d)")
                                   self.windDirection.text = "wind direction: \(d)"
                               }
                               
                           }
                        }
                        //direction use if statesments to determine range of degree and choose N E S W
                            
                        if let sys = jsonObj.value(forKey: "sys") as? NSDictionary{
                            if let sunset = sys.value(forKey: "sunset") as? NSNumber{
                                
                                let sunsetDate = Date(timeIntervalSince1970: sunset.doubleValue)
                                    let formatter = DateFormatter()
                                    formatter.dateStyle = .none
                                formatter.timeStyle = .short
                                
                                let formattedTime = formatter.string(from: sunsetDate)
                                   print(formattedTime)
                                   DispatchQueue.main.async {
                                       self.sunsetTimeOutlet.text = "sunset: \(formattedTime)"
                                   }
                                
                            }
                        }
                        
                        if let main = jsonObj.value(forKey: "main") as? NSDictionary{
                            if let temp = main.value(forKey: "temp") as? Double{
                                print(temp)
                                //makes it happen on main thread
                                DispatchQueue.main.async {
                                    self.labelOutlet.text = "temp: \(temp)"
                                }
                                
                            }
                            if let humidity = main.value(forKey: "humidity") as? Int{
                                DispatchQueue.main.async {
                                    self.humidityLabel.text = "humidity: \(humidity)"
                                }
                            }
                            if let maxTemp = main.value(forKey: "temp_max") as? Double{
                                print(maxTemp)
                                //makes it happen on main thread
                                DispatchQueue.main.async {
                                    self.maxTempOutlet.text = "max temp: \(maxTemp)"
                                }
                                
                            }
                            
                            if let minTemp = main.value(forKey: "temp_min") as? Double{
                                print(minTemp)
                                //makes it happen on main thread
                                DispatchQueue.main.async {
                                    self.minTempOutlet.text = "min temp : \(minTemp)"
                                }
                                
                            }
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                        
                    }
                }
                
                else{
                    print("can't find data")
                }
                
            }
        }
        dataTask.resume()
        
        
    }

}

