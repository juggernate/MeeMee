//
//  Meme.swift
//  MeeMee
//
//  Created by Nathan Allison on 3/17/15.
//  Copyright (c) 2015 shondicon. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    
    // should images be optional so they start nil, or does editor just have an empty
    let topLabel: String
    let bottomLabel: String
    let image: UIImage
    let memeImage : UIImage
}

extension Meme {
    
    //should have a default image included?
    static let defaultTopText = "TOP"
    static let defaultBottomText = "BOTTOM"
    
}