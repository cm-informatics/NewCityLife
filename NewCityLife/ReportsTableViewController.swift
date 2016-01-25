//
//  ReportsTableViewController.swift
//  NewCityLife
//
//  Created by Christian Mansch on 13.01.16.
//  Copyright © 2016 Christian Mansch. All rights reserved.
//

import UIKit
import CoreLocation

class ReportsTableViewController: UITableViewController, CLLocationManagerDelegate
{

    //var reportDictionary = [NSObject:NSObject]()
    
    var reportDictionary = [NSObject:NSObject]()
        {
        didSet
            {
                print("Has been set to \(reportDictionary)")
                self.tableView.reloadData()
            }
        }

    let report = Report(image: UIImage(), category: "", locationData: (0,0), comment: "", timestamp: NSDate())
    
    
    let locationManager = CLLocationManager()
    
    
    // MARK: - AppLifeCycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        let current_date = NSDate()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyy HH:mm:ss"
        print(dateFormatter.stringFromDate(current_date))
        
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
            
        }
        else
        {
            print("Location Service not enabled")
        }
       
    }
    
    override func viewDidAppear(animated: Bool)
    {
        
    }

    
    
    // MARK: - Unwind Segues
    
    @IBAction func backNavigation(sender: UIStoryboardSegue)
    {
        print("Der Identifier ist: \(sender.identifier!)")
        
        if sender.identifier! == "categoryUnwind"
        {
            let sourceViewController = sender.sourceViewController as! IssueTableViewController
        
            let indexPath = sourceViewController.tableView.indexPathForSelectedRow
        
            let cell = sourceViewController.tableView.cellForRowAtIndexPath(indexPath!)
            print(cell?.textLabel?.text)
        
            reportDictionary["category"] = cell?.textLabel?.text!
            //category = (cell?.textLabel?.text!)!
            //self.tableView.reloadRowsAtIndexPaths(<#T##indexPaths: [NSIndexPath]##[NSIndexPath]#>, withRowAnimation: <#T##UITableViewRowAnimation#>)
        }
        
        if sender.identifier! == "commentUnwind"
        {
            let sourceViewController = sender.sourceViewController as! CommentViewController
            print(sourceViewController.commentTextView.text!)
            
            reportDictionary["comment"] = sourceViewController.commentTextView.text!
        }

    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let imageCell = tableView.dequeueReusableCellWithIdentifier("imageCell", forIndexPath: indexPath) as! ImageTableViewCell

            imageCell.imageCellLabel.text = "Bild"
            imageCell.detailTextLabel?.text = "wählen"
            
            return imageCell
        }
        else if indexPath.row == 1
        {
            let categoryCell = tableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath)
            
            categoryCell.textLabel?.text = "Kategorie"
            categoryCell.accessoryType = .DisclosureIndicator
            
            if let category = reportDictionary["category"]
            {
                categoryCell.detailTextLabel?.text = category as? String
            }
            else
            {
                categoryCell.detailTextLabel?.text = "wählen"
            }
            
            return categoryCell
        }
        else if indexPath.row == 2
        {
            let locationCell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath)
            
            locationCell.textLabel?.text = "Location"
            if let location = reportDictionary["location"]
            {
                
                locationCell.detailTextLabel?.textColor = UIColor.grayColor()
                locationCell.detailTextLabel?.text = location as? String
            }
            else
            {
                locationCell.detailTextLabel?.textColor = UIColor.redColor()
                locationCell.detailTextLabel?.text = "Ortsbestimmung nicht möglich"


            }
                        
            return locationCell
        }
        else
        {
            let commentCell = tableView.dequeueReusableCellWithIdentifier("descriptionCell", forIndexPath: indexPath)
            
            commentCell.textLabel?.text = "Beschreibung"
            commentCell.accessoryType = .DisclosureIndicator
            
            if let comment = reportDictionary["comment"]
            {
                commentCell.detailTextLabel?.text = comment as? String
            }
            else
            {
                commentCell.detailTextLabel?.text = "wählen"
            }

            return commentCell
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return 110
        }
        return tableView.rowHeight
    }
    
    
    // MARK: - CLLocationManager Delegate
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        print("Latitude: \(newLocation.coordinate.latitude)")
        print("Longitude: \(newLocation.coordinate.longitude)")
        
        
        manager.stopUpdatingLocation()

        report.locationData.breitengrad = newLocation.coordinate.latitude
        report.locationData.längengrad = newLocation.coordinate.longitude
        
        //let ip = NSIndexPath(forRow: 2, inSection: 0)
        
        //self.tableView.reloadRowsAtIndexPaths([ip], withRowAnimation: .Automatic)
        
        reportDictionary["location"] = "\(newLocation.coordinate.longitude), \(newLocation.coordinate.latitude)"
        
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        manager.stopUpdatingLocation()
        print("\(error)")
        
        //reportDictionary["location"] = "Ortsbestimmung nicht möglich"
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

