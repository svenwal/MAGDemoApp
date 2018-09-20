//
//  SecondViewController.swift
//  Team1Bank
//
//  Created by Sven Walther on 19.09.18.
//  Copyright © 2018 Sven Walther. All rights reserved.
//

import UIKit
import MASFoundation
import MapKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileTextfieldOutlet: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        

        let builder = MASRequestBuilder.init(httpMethod: "GET")
        builder.endPoint = "/mws-team1/account/profile"
        builder.isPublic = false
        builder.responseType = .json
        
        MAS.invoke(builder.build()!) { (httpresponse, response, error) in
            if response != nil {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                    // here "jsonData" is the dictionary encoded in JSON data
                    print(">>>>>>>>> jsonData")
                    print(jsonData)
                    
                        let profile = try JSONDecoder().decode(Profile.self, from: jsonData)
                        self.profileTextfieldOutlet.text = profile.firstname + " " + profile.lastname  + "\n" + profile.address.street + "\n" + profile.address.city + " " + profile.address.zip
                    
                    
                    
                    DispatchQueue.main.async {
                        
                        let centerLongitude = -123.11877874021314
                        let centerLatitude = 49.28383201672765
                        
                        let span = MKCoordinateSpanMake(0.1, 0.1)
                        let region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(centerLatitude, centerLongitude), span: span)
                        
                        self.mapView.setRegion(region, animated: true)
                        
                        
                        let pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(centerLatitude, centerLongitude)
                        let pinAnnotation = MKPointAnnotation()
                        pinAnnotation.coordinate = pinLocation
                        pinAnnotation.title = profile.firstname + " " + profile.lastname
                        pinAnnotation.subtitle = profile.address.street + "\n" + profile.address.city + " " + profile.address.zip
                    
                        self.mapView.addAnnotation(pinAnnotation)
                    }
              
                
                    
                    
                    
                }
                catch
                {
                    print(error)
                }
            
            }
            else if error != nil
            {
                //self.balanceOutlet.text = "Not able to connect to backend"
                //print("error when calling API: \(error)")
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
