//
//  ContentView.swift
//  Shared
//
//  Created by Alan Calvillo on 22/05/21.
//

import SwiftUI
import CoreLocation
import Alamofire


var locationManager = CLLocationManager()
var currentLocation: CLLocation!
var latitude : Double = 0
var longitude : Double = 0
var timer: DispatchSourceTimer?


func locationManager(_ manager: CLLocationManager) {
    guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
    // set the value of lat and long
    latitude = location.latitude
    longitude = location.longitude

}
func x(phoneAddress: String) -> Void
{
    var returnData = "GPS Not Saved"
    

    // For use in foreground
    // You will need to update your .plist file to request the authorization
    locationManager.requestAlwaysAuthorization()
    locationManager.requestWhenInUseAuthorization()

    if CLLocationManager.locationServicesEnabled() {
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager(locationManager)
        returnData = "GPS Saved"
    }
    DispatchQueue.global(qos: .userInitiated).async {
        print("This is run on a background queue")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            locationManager.allowsBackgroundLocationUpdates = true
            
            //while (1 == 1)
            //{
                locationManager(locationManager)
                print(latitude)
                print(longitude)
                print(phoneAddress)
                let parameters = ["cellNumber": String(phoneAddress), "lat":String(latitude), "long":String(longitude)]

                AF.request("http://com-geored.uaa.mx:8080/save",method: .post, parameters: parameters).response { response in
                debugPrint(response)
                }
               
                //sleep(20)
                
            //}
    var timer = Timer.scheduledTimer(withTimeInterval: 120, repeats: true) {
        (_) in
                x(phoneAddress: phoneAddress)
            }
        }
    }
    
    
}


struct ContentView: View {
    @State private var phoneAddress = ""
    
    var body: some View {
        Form{
            Section{
                    Text("Can you please provide your phone number")
                        .padding()
                    
                    TextField("phone", text: $phoneAddress)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                Button(action: {x(phoneAddress: phoneAddress)}, label: {
                        Text("Start Tracking")})
                }
            }
        
       
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

