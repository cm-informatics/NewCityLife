//
//  Report.swift
//  NewCityLife
//
//  Created by Christian Mansch on 13.01.16.
//  Copyright © 2016 Christian Mansch. All rights reserved.
//

import UIKit

class Report
{
    var image: UIImage
    var category: String
    var locationData = (längengrad: 0.0, breitengrad: 0.0)
    var comment: String
    var timestamp: NSDate
    
    init(image:UIImage, category:String, locationData:(längengrad: Double, breitengrad:Double), comment:String, timestamp: NSDate)
    {
        self.image = image
        self.category = category
        self.comment = comment
        self.locationData = locationData
        self.timestamp = timestamp
    }
    
    init()
    {
        self.image = UIImage()
        self.category = ""
        self.comment = ""
        self.timestamp = NSDate()
        self.locationData = (längengrad: 0.0, breitengrad: 0.0)
    }

}