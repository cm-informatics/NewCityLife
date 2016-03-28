//
//  MyReportsTableViewCell.swift
//  NewCityLife
//
//  Created by Christian Mansch on 02.02.16.
//  Copyright © 2016 Christian Mansch. All rights reserved.
//

import UIKit

class MyReportsTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var issueImageView: UIImageView!
    var reportNumber: String = ""
    
}
