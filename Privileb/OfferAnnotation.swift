
//
//  File.swift
//  Privileb
//
//  Created by SSS on 6/30/17.
//  Copyright © 2017 omran. All rights reserved.
//

import Foundation
import MapKit
import UIKit
class OfferAnnotation: NSObject,MKAnnotation {
    var offer: offer
    var coordinate: CLLocationCoordinate2D
    var image :UIImage
    
    init(offer: offer,coordinate:CLLocationCoordinate2D,image:UIImage) {
        self.offer = offer
        self.coordinate = coordinate
        self.image = image
    }
    
    var title: String? {
        return offer.retailer_name
    }
    
    var subtitle: String? {
        return offer.offer_name
    }

}
