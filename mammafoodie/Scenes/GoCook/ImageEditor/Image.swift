//
//  Image.swift
//  Filters
//
//  Created by Arjav Lad on 18/05/17.
//  Copyright © 2017 Aakar Solutions. All rights reserved.
//

import Foundation
import CoreImage
import UIKit
import ImageIO


/// image class is a custom class
struct Image {
    let image : UIImage
    var thumbnail : UIImage?
    var appliedfilter: Filter?
    
    
    init(_ oImage:UIImage) {
        self.image = oImage
        self.thumbnail = UIImage.generateThumb(oImage)
    }
    
    init(_ oImage:UIImage, thumb: UIImage?) {
        self.image = oImage
        self.thumbnail = thumb
    }
    
    init(_ image: UIImage, thumb: UIImage?, filter:Filter?) {
        self.appliedfilter = filter
        self.image = image
        self.thumbnail = thumb
    }
    
}

struct Filter {
    let name: String!
    let filterName: String!
}
