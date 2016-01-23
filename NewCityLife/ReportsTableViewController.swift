//
//  ReportsTableViewController.swift
//  NewCityLife
//
//  Created by Christian Mansch on 13.01.16.
//  Copyright © 2016 Christian Mansch. All rights reserved.
//

import UIKit

class ReportsTableViewController: UITableViewController {

    let report = Report(image: UIImage(), category: "", locationData: (0,0), comment: "", timestamp: NSDate())
    
    
    var reportDictionary = [NSObject:NSObject]()
    
    var category: String = ""
        {
            didSet
            {
                //report.category = category
                print("Category was set to: \(report.category)")
                
                // Eine Idee wäre hier jetzt die categorie an den Textlabel der Zelle zu
                // übergeben. Das macht man mit allen werten und erst ganz zum Schluss
                // wird das Report-Objekt erzeugt
                
                /*reportDictionary["category"] = category
                print(reportDictionary)
*/
            }
        
        }
    
    /*var comment: String = ""
        {
            didSet
            {
                report.comment = comment
                print("Comment was set to: \(report.comment)")
                
            }
        
    }
*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
       //report.comment
    }
    
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
        
            //var uws = UIStoryboardUnwindSegueSource()
        }
        
        if sender.identifier! == "commentUnwind"
        {
            let sourceViewController = sender.sourceViewController as! CommentViewController
            print(sourceViewController.commentTextView.text!)
            
            reportDictionary["comment"] = sourceViewController.commentTextView.text!
        }

    }
    

    override func viewWillAppear(animated: Bool)
    {
        if reportDictionary.count > 0
        {
            tableView.reloadData()
            print("Im Dict ist etwas drin")
        }
        
        //print("IndexPathForSelectedRow: \(self.tableView.indexPathForSelectedRow)")
        
        
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let imageCell = tableView.dequeueReusableCellWithIdentifier("imageCell", forIndexPath: indexPath)

            imageCell.textLabel?.text = "Bild"
            imageCell.detailTextLabel?.text = "wählen"
            
            return imageCell
        }
        else if indexPath.row == 1
        {
            let categoryCell = tableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath)
            
            categoryCell.textLabel?.text = "Kategorie"
            
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
            locationCell.detailTextLabel?.text = "wählen"
            
            return locationCell
        }
        else if indexPath.row == 3
        {
            let dateCell = tableView.dequeueReusableCellWithIdentifier("dateCell", forIndexPath: indexPath)
            
            dateCell.textLabel?.text = "Datum"
            dateCell.detailTextLabel?.text = "wählen"
            
            return dateCell
        }
        else
        {
            let commentCell = tableView.dequeueReusableCellWithIdentifier("descriptionCell", forIndexPath: indexPath)
            
            commentCell.textLabel?.text = "Beschreibung"
            
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
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

