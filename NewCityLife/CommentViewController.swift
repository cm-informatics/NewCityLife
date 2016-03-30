//
//  CommentViewController.swift
//  NewCityLife
//
//  Created by Christian Mansch on 14.01.16.
//  Copyright © 2016 Christian Mansch. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var commentTextView: UITextView!
    
    override func viewWillAppear(animated: Bool)
    {
        commentTextView.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        commentTextView.layer.borderWidth = 0.5
        commentTextView.layer.borderColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1).CGColor
        commentTextView.layer.cornerRadius = 6.0
    }
    
    
    func textViewDidBeginEditing(textView: UITextView)
    {
        
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelAction(sender: UIBarButtonItem)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func saveAction(sender: UIBarButtonItem)
    {
        let vc:ReportsTableViewController = ReportsTableViewController()
        
        if let value = commentTextView.text
        {
            //vc.comment = value
            vc.reportDictionary["comment"] = value
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
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
