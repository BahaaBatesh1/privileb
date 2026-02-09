//
//  GrayTextField.swift
//  Pizza-Hut
//
//  Created by SSS on 6/25/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class GrayTextField: UITextField {
    override func draw(_ rect: CGRect) {
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
        self.font = UIFont(name: "MuseoSansW01-Rounded500", size: 15.0)
    }

}
