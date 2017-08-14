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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if (indexPath as NSIndexPath).row == 0
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
            cell.textLabel?.text = keyArray.object(at: (indexPath as NSIndexPath).row) as? String

            cell.detailTextLabel?.text = "\(report.category)"
            return cell
        }
        
        else if (indexPath as NSIndexPath).row == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
            cell.textLabel?.text = keyArray.object(at: (indexPath as NSIndexPath).row) as? String

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
            dateFormatter.timeZone = TimeZone.current
            
            cell.detailTextLabel?.text = dateFormatter.string(from: report.timestamp)
            return cell
        }
        
        else if (indexPath as NSIndexPath).row == 2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
            cell.textLabel?.text = keyArray.object(at: (indexPath as NSIndexPath).row) as? String

            cell.detailTextLabel?.text = "\(report.locationData.längengrad), \(report.locationData.breitengrad)"
            cell.accessoryType = .disclosureIndicator
            return cell
        }

        else if (indexPath as NSIndexPath).row == 3
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
            cell.textLabel?.text = keyArray.object(at: (indexPath as NSIndexPath).row) as? String

            cell.detailTextLabel?.text = "\(report.comment)"
            cell.accessoryType = .disclosureIndicator
            return cell
        }

       else if (indexPath as NSIndexPath).row == 4
        {
            let imageCell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageTableViewCell
            
            imageCell.imageCellLabel?.text = keyArray.object(at: (indexPath as NSIndexPath).row) as? String
            imageCell.imageCellImageView.image = report.image
            imageCell.accessoryType = .disclosureIndicator
            
            return imageCell

        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
            return cell
        }
       
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).row == 4
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "fullImageSegue"
        {
            let divc: DetailImageViewController = segue.destination as! DetailImageViewController
            divc.report = report
        }
        if segue.identifier == "commentSegue"
        {
            let fcvc:FullCommentViewController = segue.destination as! FullCommentViewController
            fcvc.report = report
        }
        if segue.identifier == "locationSegue"
        {
            let mvv:MapViewViewController = segue.destination as! MapViewViewController
            mvv.report = report
            
        }
    }
    
}
