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
        
        if report.category != ""
        {
        let location = CLLocationCoordinate2D(latitude: report.locationData.breitengrad, longitude: report.locationData.längengrad)
        
            let span = MKCoordinateSpanMake(0.25, 0.25)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = report.category
            annotation.subtitle = report.comment
        
            mapView.addAnnotation(annotation)
        }
        
    }
    
    // MARK: - CustomView
    
    func additionalCallout(_ heightOfStandardCallout: CGFloat) -> UIView
    {
        var customView = UIView()
        
        if heightOfStandardCallout <= 180.0
        {
            print("drunter")
            customView = UIView(frame: CGRect(x: (self.view.frame.size.width-kWidth)/2, y: 150, width: kWidth, height: 100))
        }
        else
        {
            print("drüber")
            customView = UIView(frame: CGRect(x: (self.view.frame.size.width-kWidth)/2, y: heightOfStandardCallout-200, width: kWidth, height: 100))
        }
        
        
        let customButton = UIButton(type: .custom)
        customButton.frame = CGRect(x: 280, y: 0, width: 20, height: 20)
        customButton.setImage(UIImage(named: "x-image.png"), for: UIControlState())
        customButton.addTarget(self, action: #selector(doAction(_:)), for: UIControlEvents.touchUpInside)
        
        let customLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 295, height: 95))
        customLabel.numberOfLines = 0
        customLabel.font = UIFont(name: "Verdana", size: 10)
        customLabel.text = "Hier könnten zusätzliche Infos stehen."
        
        
        customView.backgroundColor = UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.8)
        customView.layer.borderWidth = 1.5
        customView.layer.borderColor = UIColor.black.cgColor
        customView.addSubview(customButton)
        customView.addSubview(customLabel)
        
        
        return customView
    }
    
    func doAction(_ buttonView: UIView)
    {
        buttonView.superview?.removeFromSuperview()
    }

    func handleTap(_ gestureRecognizer: UITapGestureRecognizer)
    {
        print("You tapped the \(gestureRecognizer.view!.classForCoder)")
        self.performSegue(withIdentifier: "calloutImageSegue", sender: gestureRecognizer)
    }
    
    
    // MARK: - MapView Delegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "Report"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil
        {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
        }
        else
        {
            annotationView?.annotation = annotation
        }
        
        let btn = UIButton(type: .detailDisclosure)
        annotationView?.rightCalloutAccessoryView = btn
       
        let annotationImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 59, height: 59))
        annotationImageView.image = report.image
        annotationView?.leftCalloutAccessoryView = annotationImageView
        
        annotationImageView.isUserInteractionEnabled = true
        
        let tgr = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        annotationImageView.addGestureRecognizer(tgr)
        
        return annotationView
}
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        //mapView.addSubview(additionalCallout(view.frame.origin.y))
        
        performSegue(withIdentifier: "calloutCommentSegue", sender: view)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "calloutImageSegue"
        {
            let divc: DetailImageViewController = segue.destination as! DetailImageViewController
            divc.report = report
        }
        
        if segue.identifier == "calloutCommentSegue"
        {
            let fcvc: FullCommentViewController = segue.destination as! FullCommentViewController
            fcvc.report = report
            
        }
    }
}
