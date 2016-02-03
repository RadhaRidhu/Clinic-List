//
//  ViewController.swift
//  ClinicList
//
//  Created by Radha Vignesh on 2/1/16.
//  Copyright © 2016 Radha Natesan. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var clinicDetailsCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    //Create Array of model object
    var clinicList = [ClinicList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        //set the background color for the collection view
        clinicDetailsCollectionView.backgroundColor = UIColor.clearColor()
        clinicDetailsCollectionView.showsVerticalScrollIndicator  = false
        
        //set layout properties for collection view
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 20
        
        //dispatch the json parsing job into global queue so that the UI is not blocked
        let qualityOfServiceClass = QOS_CLASS_USER_INITIATED
        dispatch_async(dispatch_get_global_queue(qualityOfServiceClass, 0)) {
            //parse clinicList.json file and load the data into ClinicList class
            self.loadDataFromJSON()
            dispatch_async(dispatch_get_main_queue()) {
                //Reload collection view
                self.clinicDetailsCollectionView.reloadData()
            }
        }
        
    }


    
    
    //parse clinicList.json file and load the data into ClinicList class
    func loadDataFromJSON()
    {
        let fileName = NSBundle.mainBundle().pathForResource("clinicList", ofType: "json")
        
        do {
            let JSONData = try NSData(contentsOfURL: NSURL(fileURLWithPath: fileName!), options: NSDataReadingOptions.DataReadingMappedIfSafe)
           
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(JSONData, options: [])[0] as! [String: AnyObject]
              
                
                let clinicListRecommendation = json["recommendations"]!
                
                
                for anItem in clinicListRecommendation as! [[NSString : AnyObject]]
                {
                    clinicList.append(ClinicList.createClinicList(anItem)!)
                   
                }
                
            } catch {
                print(error) //Error if NSJSONSerialization fails
            }
            
        } catch let error as NSError
        {
            print(error.localizedDescription) //Error if json file is invalid
        }
    }
    

    // ********** - UICollectionViewDataSource protocol - **********
    
    //Number of collection view cells
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clinicList.count;
    }
    
    //Update collection view cell values
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("clinicDetailCell", forIndexPath: indexPath) as! clinicsOverviewCell
        
        cell.clinicName.text = clinicList[indexPath.row].clinicName
        if clinicList[indexPath.row].clinicPreference        {
            cell.preference.text = "Is Preferred: Yes"
        }
        else
        {
            cell.preference.text = "Is Preferred: No"
        }
        return cell

    }

    
    // ********** - Segue - **********
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "clinic details screen" {
            let nextScene =  segue.destinationViewController as! ClinicDetailsViewController
            
            let indexPath = self.clinicDetailsCollectionView.indexPathsForSelectedItems()![0]
            nextScene.clinicDetail = clinicList[indexPath.row]

        }
    }
    
}

