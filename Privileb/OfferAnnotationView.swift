//
//  OfferAnnotationView.swift
//  Privileb
//
//  Created by SSS on 6/30/17.
//  Copyright © 2017 omran. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class OfferAnnotationView: MKAnnotationView {
    weak var customCalloutView: OfferMapView?

    override var annotation: MKAnnotation? {
        willSet { customCalloutView?.removeFromSuperview() }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false // 1
        let pinImage = UIImage(named:"pin")
        //self.image = UIImage(named:"pin")
        let size = CGSize(width: 30, height: 40)
        
        UIGraphicsBeginImageContext(size)
        pinImage?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = resizedImage
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.canShowCallout = false // 1
        let pinImage = UIImage(named:"pin")
        //self.image = UIImage(named:"pin")
        let size = CGSize(width: 30, height: 40)
        
        UIGraphicsBeginImageContext(size)
        pinImage?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = resizedImage
        

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected { // 2
            self.customCalloutView?.removeFromSuperview() // remove old custom callout (if any)
            
            if let newCustomCalloutView = loadPersonDetailMapView() {
                // fix location from top-left to its right place.
                newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
                newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height
                
                // set custom callout view
                self.addSubview(newCustomCalloutView)
                self.customCalloutView = newCustomCalloutView
                
                // animate presentation
                if animated {
                    self.customCalloutView!.alpha = 0.0
                    UIView.animate(withDuration: 0.2, animations: {
                        self.customCalloutView!.alpha = 1.0
                    })
                }
            }
        } else { // 3
            if customCalloutView != nil {
                if animated { // fade out animation, then remove it.
                    UIView.animate(withDuration: 0.2, animations: {
                        self.customCalloutView!.alpha = 0.0
                    }, completion: { (success) in
                      //  self.customCalloutView!.removeFromSuperview()
                    })
                } else { self.customCalloutView!.removeFromSuperview() } // just remove it.
            }
        }
    }

    
    func loadPersonDetailMapView() -> OfferMapView? { // 4
        if let views = Bundle.main.loadNibNamed("OfferMapView", owner: self, options: nil) as? [OfferMapView], views.count > 0 {
            let offerMapView = views.first
            if let offerAnnotaion = annotation as? OfferAnnotation {
                let offer = offerAnnotaion.offer
                offerMapView?.cofigureView(offer: offer)
            }
            return offerMapView
        }
        return nil
    }
    
    override func prepareForReuse() { // 5
        super.prepareForReuse()
        self.customCalloutView?.removeFromSuperview()
    }
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if (hitView != nil)
        {
            self.superview?.bringSubview(toFront: self)
        }
        return hitView
    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.bounds
        var isInside = rect.contains(point)
        
        if (!isInside) {
            for subview in subviews {
                isInside = subview.frame.contains(point)
                
                if (isInside) {
                    break
                }
            }
        }
        
        print(isInside)
        
        return isInside;
        
    }
}
