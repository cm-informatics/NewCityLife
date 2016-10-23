//
//  MyReportsTableViewController.swift
//  NewCityLife
//
//  Created by Christian Mansch on 01.02.16.
//  Copyright © 2016 Christian Mansch. All rights reserved.
//

import UIKit

class MyReportsTableViewController: UITableViewController {

    var sortedReportKeys = [String]()
    var listOfAllReports: NSDictionary = [:]
    var report: Report = Report()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.title = "My Reports"
        self.navigationController?.navigationBar.tintColor = UIColor.blue
        
        let fileManager = FileManager()
        
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        
        let reportsPath = URL(fileURLWithPath: documentPath!, isDirectory: true).appendingPathComponent("Reports")
        
        let pListPath = reportsPath.appendingPathComponent("myReports.plist", isDirectory: false)
        
        var isDir: ObjCBool = false
        
        //Es wird direkt überprüft ob die plist-Datei an einem bestimmten Pfad existiert. Ist dies der Fall,
        //existiert auch der Pfad automatisch. Existiert die Datei nicht, gibt es auch den Pad nicht.
        if fileManager.fileExists(atPath: pListPath.path, isDirectory: &isDir)
        {
            print("Datei existiert bereits")
            
            listOfAllReports = NSMutableDictionary(contentsOf: pListPath)!
            let allKeysOfTheReports: [String] = listOfAllReports.allKeys as! [String]
            sortedReportKeys = allKeysOfTheReports.sorted(by: >)
            
            print(sortedReportKeys)
        }
        else
        {
            print("Datei nicht vorhanden")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedReportKeys.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myReportsTableViewCell", for: indexPath) as! MyReportsTableViewCell

        // Configure the cell...
        
        //let aSingleReport = listOfAllReports.object(forKey: sortedReportKeys.object(at: (indexPath as NSIndexPath).row)) as! NSDictionary
        
        let aSingleReport = listOfAllReports.object(forKey: sortedReportKeys[indexPath.row]) as! NSDictionary
        
        //cell.reportNumber = sortedReportKeys.object(at: (indexPath as NSIndexPath).row) as! String
        cell.reportNumber = sortedReportKeys[indexPath.row]
        
        cell.categoryLabel.text = aSingleReport.object(forKey: "category") as? String
        cell.dateLabel.text = aSingleReport.object(forKey: "date") as? String
        
        if let currentLocation = aSingleReport.object(forKey: "location") as? [Double]
        {
            cell.locationLabel.text = "\(currentLocation[0]), \(currentLocation[1])"
        }
        
        cell.issueImageView.image = UIImage(data: aSingleReport.object(forKey: "image") as! Data)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "\(listOfAllReports.count) Report(s)"
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        let dtvc: DetailReportTableViewController = segue.destination as! DetailReportTableViewController
        
        let indexPath = tableView.indexPathForSelectedRow
        
        let cell = tableView.cellForRow(at: indexPath!) as! MyReportsTableViewCell
        print("The ReportNumber is: \(cell.reportNumber)")
        
        for singleReport in listOfAllReports
        {
            if singleReport.key as! String == cell.reportNumber
            {
                print("Bericht gefunden.")
                let valueDict = singleReport.value as! NSDictionary
                
                report.category = valueDict.object(forKey: "category") as! String
                report.comment = valueDict.object(forKey: "comment") as! String
               
                
                if let dateTime = valueDict.object(forKey: "date")
                {
                    let df = DateFormatter()
                    df.dateFormat = "dd-MM-yyy HH:mm:ss"
                    
                    report.timestamp = df.date(from: dateTime as! String)!
                }
                
                if let locationData = valueDict.value(forKey: "location")
                {
                    report.locationData.längengrad = (locationData as AnyObject).objectAt(0) as! Double
                    
                    report.locationData.breitengrad = (locationData as AnyObject).objectAt(1) as! Double
                    
                }
                
                if let imageData = valueDict.value(forKey: "image")
                {
                    report.image = UIImage(data: (imageData as! NSMutableData) as Data, scale: 1.0)!
                }
            }
        }
        
        /*
        print("Category: \(report.category)")
        print("Datum: \(report.timestamp)")
        print("Location: \(report.locationData)")
        print("Comment: \(report.comment)")
        print("Image: \(report.image)")
         */
        
        dtvc.report = report
        
    }
    
}
