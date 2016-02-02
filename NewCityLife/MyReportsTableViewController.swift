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
            
            
            //let sortedReportKeys = allKeysOfTheReports.sortedArrayUsingDescriptors(NSSortDescriptor(key: nil, ascending: false, selector: "compare:"))
            
            sortedReportKeys = allKeysOfTheReports.sortedArrayUsingDescriptors([NSSortDescriptor(key: nil, ascending: false, selector: "compare:")])
            
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
        
        //cell.categoryLabel.text = aSingleReport.objectForKey("
        cell.categoryLabel.text = aSingleReport.objectForKey("category") as? String
        cell.dateLabel.text = aSingleReport.objectForKey("date") as? String
        cell.locationLabel.text = aSingleReport.objectForKey("location") as? String
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
