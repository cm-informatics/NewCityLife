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
    //var reportDictionary:NSMutableDictionary = [:] // Diese Deklaration wäre vielleicht besser
    var reportDictionary = [String:AnyObject]()
        {
        didSet
            {
                //print("Has been set to \(reportDictionary)")
                self.tableView.reloadData()
            }
        }
    
    let report = Report()
    
    let locationManager = CLLocationManager()
    
    
    // MARK: - AppLifeCycle
    
   override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Neuen Report erstellen"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = true
        
        //print(navigationItem.titleView?.tintColor as Any)
        //navigationItem.titleView?.tintColor = UIColor.red
        //navigationItem.titleView?.backgroundColor = UIColor.black
        
        //print(self.navigationController?.navigationItem.title as Any)
        print(navigationItem)
        
        let sendButton = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(ReportsTableViewController.sendAction(_:)))
        self.navigationItem.rightBarButtonItem = sendButton
        
        let current_date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyy HH:mm:ss"
        
        reportDictionary["date"] = dateFormatter.string(from: current_date) as AnyObject?
        
        report.timestamp = dateFormatter.date(from: reportDictionary["date"] as! String)!
        
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
    
    @IBAction func backNavigation(_ sender: UIStoryboardSegue)
    {
        
        if sender.identifier! == "categoryUnwind"
        {
            let sourceViewController = sender.source as! IssueTableViewController
            let indexPath = sourceViewController.tableView.indexPathForSelectedRow
            let cell = sourceViewController.tableView.cellForRow(at: indexPath!)
        
            reportDictionary["category"] = cell?.textLabel?.text! as AnyObject?
        }
        
        if sender.identifier! == "commentUnwind"
        {
            let sourceViewController = sender.source as! CommentViewController
            print(sourceViewController.commentTextView.text!)
            
            reportDictionary["comment"] = sourceViewController.commentTextView.text! as AnyObject?
        }

    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (indexPath as NSIndexPath).row == 0
        {
            let imageCell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageTableViewCell

            imageCell.imageCellLabel!.text = "Bild"
            
            if let image = reportDictionary["image"]
            {
                imageCell.imageCellImageView.image = image as? UIImage
            }
            
            return imageCell
        }
            
        else if (indexPath as NSIndexPath).row == 1
        {
            let categoryCell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
            
            categoryCell.textLabel?.text = "Kategorie"
            categoryCell.accessoryType = .disclosureIndicator
            
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
        else if (indexPath as NSIndexPath).row == 2
        {
            let locationCell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
            
            locationCell.textLabel?.text = "Location"
            if let location = reportDictionary["location"] as? (längengrad: Double, breitengrad: Double)
            {
                locationCell.detailTextLabel?.text = "\(location.längengrad) , \(location.breitengrad)"
            }
            else
            {
                locationCell.detailTextLabel?.text = "Ortsbestimmung nicht möglich"
            }
            return locationCell
        }
        else
        {
            let commentCell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath)
            
            commentCell.textLabel?.text = "Beschreibung"
            commentCell.accessoryType = .disclosureIndicator
            
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).row == 0
        {
            return 110
        }
        return tableView.rowHeight
    }
    
    
    // MARK: - CLLocationManager Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        manager.stopUpdatingLocation()
        print("Location is: \(locations[0].coordinate.latitude)")
        print("Location is: \(locations[0].coordinate.longitude)")
        
        if let currentLocation = locations.first?.coordinate
        {
            report.locationData.längengrad = currentLocation.longitude
            report.locationData.breitengrad = currentLocation.latitude
        }
        
        reportDictionary["location"] = (report.locationData) as AnyObject?
        
        self.tableView.reloadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        print("\(error)")
        
        //reportDictionary["location"] = "LOcation Service failed" as AnyObject?
        reportDictionary["location"] = nil
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "commentSegue"
        {
            let indexPath = self.tableView.indexPathForSelectedRow
            let cell = self.tableView(self.tableView, cellForRowAt: indexPath!)
            
            if cell.detailTextLabel?.text != "wählen"
            {
                let navigationController: UINavigationController = segue.destination as! UINavigationController
                
                if let cvc: CommentViewController = navigationController.visibleViewController as? CommentViewController
                {
                    if let text = cell.detailTextLabel?.text
                    {
                        cvc.commentText = text
                    }
                }
                
            }
            
        }
    }
    
    
    //Um die Kamerafunktion nutzen zu können müssen spezielle Eintragungen in der plist stehen
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == 0
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                imagePicker.sourceType = .camera
                
            }
            else
            {
                imagePicker.sourceType = .photoLibrary
            }
            
            present(imagePicker, animated: true, completion: nil)
        }
    }

    // MARK: - UIImagePickerDelegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        reportDictionary["image"] = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIBarButton Actions
    
    func sendAction(_ sender: AnyObject)
    {
        print(reportDictionary.count)
        
        if reportDictionary.count == 5  // Wenn genau fünf Werte vorliegen
        {
            print("Alles drin: \(reportDictionary.values)")
            
            
            report.image = reportDictionary["image"] as! UIImage
            
            let imageData = NSData(data: UIImageJPEGRepresentation(report.image, 0.2)!) as Data
            reportDictionary["image"] = imageData as AnyObject?
            
            //Längen- und Breitengrad auf 9 Stellen nach dem Komma runden
            
            report.locationData.breitengrad = Double(round(report.locationData.breitengrad*1000000000)/1000000000)
            report.locationData.längengrad = Double(round(report.locationData.längengrad*1000000000)/1000000000)
            
            //Die LocationData müssen hier noch einmal ein einen Array umgewandelt werden,
            //da ich diese sonst nicht in eine PList schreiben kann.
            
            let locationArray = [report.locationData.längengrad, report.locationData.breitengrad]
            reportDictionary["location"] = locationArray as AnyObject?
            
            
            //Ab hier liegt der report komplett vor
            
            let fileManager = FileManager()
            var pListPath: URL
            
            let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            
            if let documentDir = rootPath
            {
                let reportsPath = URL(fileURLWithPath: documentDir, isDirectory: true).appendingPathComponent("Reports")
                
                
                if fileManager.fileExists(atPath: reportsPath.path)
                {
                    print("Verzeichnis existiert bereits: \(reportsPath)")
                }
                else
                {
                    do
                    {
                        try fileManager.createDirectory(at: reportsPath, withIntermediateDirectories: false, attributes: nil)
                        print("Verzeichniss wurde erfolgreich erstellt - Dir Path: \(reportsPath)")
                    }
                    catch
                    {
                        print("Fehler bei der Verzeichniss-Erstellung")
                        print("Der Fehler ist \(error)")
                    }
                  
                }
                
                // Das Verzeichniss existiert jetzt, also wird jetzt die myReports.plist -Datei angelegt.
                
                pListPath = reportsPath.appendingPathComponent("myReports.plist", isDirectory: false)
                
                var isDir: ObjCBool = false
                
                if fileManager.fileExists(atPath: pListPath.path, isDirectory: &isDir)
                    {
                        print("File already exits")
                    }
                    else
                    {
                        //let success = fileManager.createFileAtPath(pListPath.path!, contents: data, attributes: nil)
                        let dictionary = NSDictionary()
                        let success = dictionary.write(to: pListPath, atomically: true)
                        
                        print("Was file created?: \(success)")
                    }
                
                //Generierung einer ID aus Datum und einer zufälligen Zahl bis maximal 9999 (10000-1)
                let current_date = Date()
                let dateFormatter = DateFormatter()
                
                dateFormatter.dateFormat = "ddMMyyyyHHmmss"
                
                let UID = dateFormatter.string(from: current_date) + "\(Int(arc4random_uniform(10000)))"
                
                if var completeReport = NSMutableDictionary(contentsOf: pListPath)
                {
                    completeReport = NSMutableDictionary(dictionary: NSMutableDictionary(contentsOf: pListPath)!)
                    
                    completeReport.setObject(reportDictionary, forKey: "Report Nr. \(UID)" as NSCopying)
                    
                    if completeReport.write(to: pListPath, atomically: true)
                    {
                        print("Writing was successful")
                        
                        let successAlert = UIAlertController(title: "Report Nr. \(UID)", message: "Daten erfolgreich gespeichert", preferredStyle: .alert)
                        
                        successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler:{(action: UIAlertAction!) -> Void in
                            _ = self.navigationController?.popToRootViewController(animated: true)
                        }))
                        
                        self.present(successAlert, animated: true, completion: nil)
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
            print("Da fehlt noch was: \(reportDictionary.enumerated())")
            
            let alertView = UIAlertController(title: "Error", message: "Fehlende Angaben. Sie haben nicht alle Felder ausgefüllt.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
        }
    }
}
