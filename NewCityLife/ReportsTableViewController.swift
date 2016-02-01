//
//  ReportsTableViewController.swift
//  NewCityLife
//
//  Created by Christian Mansch on 13.01.16.
//  Copyright © 2016 Christian Mansch. All rights reserved.
//

import UIKit
import CoreLocation

class ReportsTableViewController: UITableViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    var reportDictionary = [NSObject:NSObject]()
        {
        didSet
            {
                //print("Has been set to \(reportDictionary)")
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
        
        let sendButton = UIBarButtonItem(title: "Send", style: .Plain, target: self, action: "sendAction:")
        self.navigationItem.rightBarButtonItem = sendButton
        
        let current_date = NSDate()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyy HH:mm:ss"
        
        reportDictionary["date"] = dateFormatter.stringFromDate(current_date)
        
        report.timestamp = dateFormatter.dateFromString(reportDictionary["date"] as! String)!
        
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
    
    // MARK: - Unwind Segues
    
    @IBAction func backNavigation(sender: UIStoryboardSegue)
    {
        //print("Der Identifier ist: \(sender.identifier!)")
        
        if sender.identifier! == "categoryUnwind"
        {
            let sourceViewController = sender.sourceViewController as! IssueTableViewController
        
            let indexPath = sourceViewController.tableView.indexPathForSelectedRow
        
            let cell = sourceViewController.tableView.cellForRowAtIndexPath(indexPath!)
            print(cell?.textLabel?.text)
        
            reportDictionary["category"] = cell?.textLabel?.text!
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
            //imageCell.detailTextLabel?.text = "wählen"
            if let image = reportDictionary["image"]
            {
                imageCell.imageCellImageView.image = image as? UIImage
            }
            
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            if UIImagePickerController.isSourceTypeAvailable(.Camera)
            {
                imagePicker.sourceType = .Camera
            }
            else
            {
                print("No Media available")
            }
            
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }

    // MARK: - UIImagePickerDelegates
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        reportDictionary["image"] = selectedImage
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UIBarButton Actions
    
    func sendAction(sender: AnyObject)
    {
        print(reportDictionary.count)
        
        if reportDictionary.count == 5  // Wenn genau vier Werte vorliegen
        {
            print("Alles drin: \(reportDictionary.values)")
            
            //reportDictionary.keys.enumerate()
            
            for (_, c) in reportDictionary.keys.enumerate()
            {
                switch c
                {
                    case "image"    : report.image = reportDictionary["image"] as! UIImage
                    case "category" : report.category = reportDictionary["category"] as! String
                    case "comment"  : report.comment = reportDictionary["comment"] as! String
                    
                    default: "An error occoured"
                }
            }
            
            
            
            print("Der report: \(report.category)\n\(report.image)\n\(report.comment)")
            
            
            
            let fileManager = NSFileManager()
            
            var pListPath: NSURL
            
            let rootPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first
            //let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            
            if let documentDir = rootPath
            {
                let reportsPath = NSURL(fileURLWithPath: documentDir, isDirectory: true).URLByAppendingPathComponent("Reports")
                
                //print("Directory: \(reportsPath)")
                
                if fileManager.fileExistsAtPath(reportsPath.path!)
                {
                    print("Verzeichnis existiert bereits")
                }
                else
                {
                    do
                    {
                        try fileManager.createDirectoryAtURL(reportsPath, withIntermediateDirectories: false, attributes: nil)
                        print("Verzeichniss wurde erfolgreich erstellt - Dir Path: \(reportsPath)")
                    }
                    catch
                    {
                        print("Fehler bei der Verzeichniss-Erstellung")
                        print("Der Fehler ist \(error)")
                    }
                  
                }
                
                // Das Verzeichniss existiert jetzt, also wird jetzt die myReports.plist -Datei angelegt.
                
                //pListPath = NSURL(fileURLWithPath: String(reportsPath)).URLByAppendingPathComponent("myReports.plist", isDirectory: false)
                pListPath = NSURL(fileURLWithPath: reportsPath.path!).URLByAppendingPathComponent("myReports.plist", isDirectory: false)
                
                var isDir: ObjCBool = false
                
                if fileManager.fileExistsAtPath(pListPath.path!, isDirectory: &isDir)
                    {
                        print("File already exits")
                    }
                    else
                    {
                        //let success = fileManager.createFileAtPath(pListPath.path!, contents: data, attributes: nil)
                        let dictionary = NSDictionary()
                        let success = dictionary.writeToURL(pListPath, atomically: true)
                        
                        print("Was file created?: \(success)")
                        //print("plistPath: \(pListPath.path!)")
                    }
                
                //TODO: Create a more powerful UID
                let UID = Int(arc4random_uniform(10000))
                
                //var completeReport = NSMutableDictionary()
                
                //print("PList Path: \(pListPath.path!)")
                
                if var completeReport = NSMutableDictionary(contentsOfURL: pListPath)
                {
                    completeReport = NSMutableDictionary(dictionary: NSMutableDictionary(contentsOfURL: pListPath)!)
                    
                    //reportDictionary["image"] = "The image"
                    completeReport.setObject(reportDictionary, forKey: "Report Nr. \(UID)")
                    
                    print("CompleteReport: \(completeReport)")
                    
                    if completeReport.writeToURL(pListPath, atomically: true)
                    {
                        print("Writing was successful")
                    }
                    else
                    {
                        print("Writing failed")
                    }
                    
                }
                else
                {
                    print("An error occoured")
                }
                
            }
        }
        else
        {
            print("Da fehlt noch was: \(reportDictionary.enumerate())")
        }
    }
}