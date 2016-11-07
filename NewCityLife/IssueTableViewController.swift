//
//  IssueTableViewController.swift
//  NewCityLife
//
//  Created by Christian Mansch on 14.01.16.
//  Copyright © 2016 Christian Mansch. All rights reserved.
//

import UIKit

class IssueTableViewController: UITableViewController {

    var issues = ["Grafitti", "Verschmutzung", "Sachschaden", "Parkplatzmangel", "Wasserschaden", "Brandschaden"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return issues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "issueCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = issues[(indexPath as NSIndexPath).row]

        return cell
    }
    
    // MARK: - BarButton Actions
    @IBAction func cancelAction(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
