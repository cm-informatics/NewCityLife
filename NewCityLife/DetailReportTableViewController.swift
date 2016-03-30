//
//  DetailReportTableViewController.swift
//  NewCityLife
//
//  Created by Christian Mansch on 26.03.16.
//  Copyright © 2016 Christian Mansch. All rights reserved.
//

import UIKit

class DetailReportTableViewController: UITableViewController {

    var report:Report = Report()
    
    let keyArray: NSMutableArray = ["Kategorie", "Datum", "Location", "Beschreibung", "Bild"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.title = "Details"
        
        print("Detail-Report: \(report.category)")
        
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
        return keyArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if indexPath.row == 0
        {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath)
            cell.textLabel?.text = keyArray.objectAtIndex(indexPath.row) as? String

            cell.detailTextLabel?.text = "\(report.category)"
            return cell
        }
        
        else if indexPath.row == 1
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("dateCell", forIndexPath: indexPath)
            cell.textLabel?.text = keyArray.objectAtIndex(indexPath.row) as? String

            cell.detailTextLabel?.text = "\(report.timestamp)"
            return cell
        }
        
        else if indexPath.row == 2
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath)
            cell.textLabel?.text = keyArray.objectAtIndex(indexPath.row) as? String

            cell.detailTextLabel?.text = "\(report.locationData.längengrad), \(report.locationData.breitengrad)"
            return cell
        }

        else if indexPath.row == 3
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath)
            cell.textLabel?.text = keyArray.objectAtIndex(indexPath.row) as? String

            cell.detailTextLabel?.text = "\(report.comment)"
            return cell
        }

       else if indexPath.row == 4
        {
            let imageCell = tableView.dequeueReusableCellWithIdentifier("imageCell", forIndexPath: indexPath) as! ImageTableViewCell
            
            imageCell.imageCellLabel?.text = keyArray.objectAtIndex(indexPath.row) as? String
            imageCell.imageCellImageView.image = report.image
            
            return imageCell

        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)
            return cell
        }
       
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 4
        {
            return 110
        }
        return tableView.rowHeight
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "fullImageSegue"
        {
            let divc: DetailImageViewController = segue.destinationViewController as! DetailImageViewController
            divc.report = report
        }
        if segue.identifier == "commentSegue"
        {
            let fcvc:FullCommentViewController = segue.destinationViewController as! FullCommentViewController
            fcvc.report = report
        }
    }
    
}