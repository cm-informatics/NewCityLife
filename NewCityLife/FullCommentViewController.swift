//
//  FullCommentViewController.swift
//  NewCityLife
//
//  Created by Christian Mansch on 29.03.16.
//  Copyright © 2016 Christian Mansch. All rights reserved.
//

import UIKit

class FullCommentViewController: UIViewController {

    var report:Report = Report()
    
    @IBOutlet weak var commentTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //Damit der Text nicht in der Mitte beginnt
        self.automaticallyAdjustsScrollViewInsets = false
        
        commentTextView.layer.borderWidth = 0.5
        commentTextView.layer.borderColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1).cgColor
        commentTextView.layer.cornerRadius = 6.0
        
        commentTextView.text = report.comment
 
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
