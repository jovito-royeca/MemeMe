//
//  Meme.swift
//  MemeMe
//
//  Created by Jovit Royeca on 1/20/16.
//  Copyright © 2016 Jovito Royeca. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    var topText:String?
    var bottomText:String?
    var image:UIImage?
    var memedImage:UIImage?
    
    init(topText:String, bottomText:String, image:UIImage, memedImage:UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }
}