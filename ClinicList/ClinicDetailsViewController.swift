//
//  ClinicDetailsViewController.swift
//  ClinicList
//
//  Created by Radha Vignesh on 2/1/16.
//  Copyright © 2016 Radha Natesan. All rights reserved.
//

import UIKit
import MapKit

class ClinicDetailsViewController: UIViewController
{
    
    
    @IBOutlet weak var clinicName: UILabel!
    @IBOutlet weak var streetAddress1: UILabel!
    @IBOutlet weak var streetAddress2: UILabel!
    @IBOutlet weak var distance: UILabel!


    var clinicDetail : ClinicList!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        clinicName.text = clinicDetail.clinicName
        streetAddress1.text =  clinicDetail.location["streetName"] as? String
        streetAddress2.text =  "\(clinicDetail.location["city"] as! String), \(clinicDetail.location["stateCode"] as! String) \(clinicDetail.location["postalCode"] as! String)"
        distance.text = "\(clinicDetail.location["locationDistance"] as! float_t)"
        
    }

    
    @IBAction func onTapSeeOnMapButton(sender: UIButton)
    {
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        let placemark = MKPlacemark(coordinate: clinicDetail.coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(clinicDetail.clinicName)"
        mapItem.openInMapsWithLaunchOptions(launchOptions)
    }
}