//
//  MyReportsTableViewController.swift
//  NewCityLife
//
//  Created by Christian Mansch on 01.02.16.
//  Copyright © 2016 Christian Mansch. All rights reserved.
//

import UIKit

class MyReportsTableViewController: UITableViewController {

    var sortedReportKeys: NSArray = []
    var listOfAllReports: NSDictionary = [:]
    var report: Report = Report()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.title = "My Reports"
        self.navigationController?.navigationBar.tintColor = UIColor.blueColor()
        
        let fileManager = NSFileManager()
        
        let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first
        
        let reportsPath = NSURL(fileURLWithPath: documentPath!, isDirectory: true).URLByAppendingPathComponent("Reports")
        
        let pListPath = reportsPath.URLByAppendingPathComponent("myReports.plist", isDirectory: false)
        
        var isDir: ObjCBool = false
        
        //Es wird direkt überprüft ob die plist-Datei an einem bestimmten Pfad existiert. Ist dies der Fall,
        //existiert auch der Pfad automatisch. Existiert die Datei nicht, gibt es auch den Pad nicht.
        if fileManager.fileExistsAtPath(pListPath.path!, isDirectory: &isDir)
        {
            print("Datei existiert bereits")
            
            listOfAllReports = NSMutableDictionary(contentsOfURL: pListPath)!
            let allKeysOfTheReports = NSArray(array: listOfAllReports.allKeys)
            
            //print(allKeysOfTheReports)
            
            
            sortedReportKeys = allKeysOfTheReports.sortedArrayUsingDescriptors([NSSortDescriptor(key: nil, ascending: false, selector: #selector(NSNumber.compare(_:)))])
            
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedReportKeys.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myReportsTableViewCell", forIndexPath: indexPath) as! MyReportsTableViewCell

        // Configure the cell...
        
        let aSingleReport = listOfAllReports.objectForKey(sortedReportKeys.objectAtIndex(indexPath.row)) as! NSDictionary
        
        
        cell.reportNumber = sortedReportKeys.objectAtIndex(indexPath.row) as! String
        
        cell.categoryLabel.text = aSingleReport.objectForKey("category") as? String
        cell.dateLabel.text = aSingleReport.objectForKey("date") as? String
        cell.locationLabel.text = aSingleReport.objectForKey("location") as? String
        cell.locationLabel.text = "\(aSingleReport.objectForKey("location")![0]), \(aSingleReport.objectForKey("location")![1])"
        cell.issueImageView.image = UIImage(data: aSingleReport.objectForKey("image") as! NSData)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "\(listOfAllReports.count) Report(s)"
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
        let dtvc: DetailReportTableViewController = segue.destinationViewController as! DetailReportTableViewController
        
        let indexPath = tableView.indexPathForSelectedRow
        
        let cell = tableView.cellForRowAtIndexPath(indexPath!) as! MyReportsTableViewCell
        print("The ReportNumber is: \(cell.reportNumber)")
        
        for singleReport in listOfAllReports
        {
            if singleReport.key as! String == cell.reportNumber
            {
                print("Bericht gefunden.")
                let valueDict = singleReport.value as! NSDictionary
                
                report.category = valueDict.objectForKey("category") as! String
                report.comment = valueDict.objectForKey("comment") as! String
               
                
                if let dateTime = valueDict.objectForKey("date")
                {
                    let df = NSDateFormatter()
                    df.dateFormat = "dd-MM-yyy HH:mm:ss"
                    
                    report.timestamp = df.dateFromString(dateTime as! String)!
                }
                
                if let locationData = valueDict.valueForKey("location")
                {
                    report.locationData.längengrad = locationData.objectAtIndex(0) as! Double
                    report.locationData.breitengrad = locationData.objectAtIndex(1) as! Double
                }
                
                if let imageData = valueDict.valueForKey("image")
                {
                    report.image = UIImage(data: imageData as! NSMutableData, scale: 1.0)!
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
