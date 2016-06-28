//
//  MapViewViewController.swift
//  NewCityLife
//
//  Created by Christian Mansch on 30.03.16.
//  Copyright © 2016 Christian Mansch. All rights reserved.
//

import UIKit
import MapKit

class MapViewViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var report:Report = Report()
    
    let kWidth:CGFloat = 300
    
    
    //var customView: UIView = UIView(frame: CGRectMake(10, 10, 300, 100))
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let location = CLLocationCoordinate2D(latitude: report.locationData.breitengrad, longitude: report.locationData.längengrad)
        
        let span = MKCoordinateSpanMake(0.25, 0.25)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = report.category
        annotation.subtitle = report.comment
        
        
        mapView.addAnnotation(annotation)
        //mapView.addAnnotation(<#T##annotation: MKAnnotation##MKAnnotation#>)
        
    }
    
    // MARK: - CustomView
    
    func additionalCallout(heightOfStandardCallout: CGFloat) -> UIView
    {
        var customView = UIView()
        
        if heightOfStandardCallout <= 180.0
        {
            print("drunter")
            customView = UIView(frame: CGRectMake((self.view.frame.size.width-kWidth)/2, 150, kWidth, 100))
        }
        else
        {
            print("drüber")
            customView = UIView(frame: CGRectMake((self.view.frame.size.width-kWidth)/2, heightOfStandardCallout-200, kWidth, 100))
        }
        
        
        let customButton = UIButton(type: .Custom)
        customButton.frame = CGRectMake(280, 0, 20, 20)
        customButton.setImage(UIImage(named: "x-image.png"), forState: .Normal)
        customButton.addTarget(self, action: #selector(doAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        let customLabel = UILabel(frame: CGRectMake(5, 5, 295, 95))
        customLabel.numberOfLines = 0
        customLabel.font = UIFont(name: "Verdana", size: 10)
        customLabel.text = "Hier könnten zusätzliche Infos stehen."
        
        
        customView.backgroundColor = UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.8)
        customView.layer.borderWidth = 1.5
        customView.layer.borderColor = UIColor.blackColor().CGColor
        customView.addSubview(customButton)
        customView.addSubview(customLabel)
        
        
        return customView
    }
    
    func doAction(buttonView: UIView)
    {
        buttonView.superview?.removeFromSuperview()
    }

    func handleTap(gestureRecognizer: UITapGestureRecognizer)
    {
        print("You tapped the \(gestureRecognizer.view!.classForCoder)")
        self.performSegueWithIdentifier("calloutImageSegue", sender: gestureRecognizer)
    }
    
    // MARK: - MapView Delegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "Report"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
        if annotationView == nil
        {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
        }
        else
        {
            annotationView?.annotation = annotation
        }
        
        let btn = UIButton(type: .DetailDisclosure)
        annotationView?.rightCalloutAccessoryView = btn
       
        let annotationImageView = UIImageView(frame: CGRectMake(0, 0, 59, 59))
        annotationImageView.image = report.image
        annotationView?.leftCalloutAccessoryView = annotationImageView
        
        annotationImageView.userInteractionEnabled = true
        
        let tgr = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        annotationImageView.addGestureRecognizer(tgr)
        
        return annotationView
}
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        //mapView.addSubview(additionalCallout(view.frame.origin.y))
        
        performSegueWithIdentifier("calloutCommentSegue", sender: view)
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "calloutImageSegue"
        {
            let divc: DetailImageViewController = segue.destinationViewController as! DetailImageViewController
            divc.report = report
        }
        
        if segue.identifier == "calloutCommentSegue"
        {
            let fcvc: FullCommentViewController = segue.destinationViewController as! FullCommentViewController
            fcvc.report = report
            
        }
    }
}