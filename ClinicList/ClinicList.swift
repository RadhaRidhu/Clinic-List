//
//  ClinicList.swift
//  ClinicList
//
//  Created by Radha Vignesh on 2/1/16.
//  Copyright © 2016 Radha Natesan. All rights reserved.
//

import CoreLocation

class ClinicList: NSObject {
    let clinicId: String
    let location: [NSString:AnyObject]
    let clinicPreference : Bool
    let coordinate: CLLocationCoordinate2D
    var clinicName: String
    {
        get{//Getter for clinicName
 
            return Keychain.load(clinicId)!
           
        }
    }
    init(clinicId: String, location: [NSString:AnyObject], clinicName: String, clinicPreference : Bool, coordinate: CLLocationCoordinate2D)
    {
        self.clinicId = clinicId
        self.location = location
        self.clinicPreference = clinicPreference
        self.coordinate = coordinate
        
        Keychain.save(clinicId, name: clinicName)
        
        super.init()
    }

    
    //This function updates the ClinicList object with relevant value from the Json data
    class func createClinicList(clinicListItem: [NSString : AnyObject]) -> ClinicList? {
    

        let clinicId = clinicListItem["id"]  as! String
        let location = clinicListItem["location"] as! [NSString : AnyObject]
        let clinicName = clinicListItem["name"]  as! String
        let clinicPreference = clinicListItem["preferred"] as! Bool
        let latitude = location["geoLocation"]!["latitude"] as! Double
        let longitude = location["geoLocation"]!["longitude"] as! Double
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
   
        return ClinicList(clinicId: clinicId, location: location, clinicName: clinicName, clinicPreference:clinicPreference, coordinate: coordinate)
    }

}