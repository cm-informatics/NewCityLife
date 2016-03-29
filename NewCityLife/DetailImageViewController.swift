//
//  DetailImageViewController.swift
//  NewCityLife
//
//  Created by Christian Mansch on 29.03.16.
//  Copyright © 2016 Christian Mansch. All rights reserved.
//

import UIKit

class DetailImageViewController: UIViewController {

    @IBOutlet weak var fullImageView: UIImageView!
    var report:Report = Report()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullImageView.image = report.image
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
