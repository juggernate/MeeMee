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
    // should images be optional so they start nil? 
    // or a meme can't be a meme until all of the parts are there, the editor is just temp elements until it saves
    let topLabel: String
    let bottomLabel: String
    let image: UIImage
    let memeImage : UIImage
    
    // Not sure if this is the best place? maybe this should just be in the memeEditorController?
    static func presentMemeEditor(meme: Meme?, fromViewController: UIViewController) {
        var storyboard = UIStoryboard (name: "Main", bundle: nil)
        var memeEditor = storyboard.instantiateViewControllerWithIdentifier("MemeEditor") as MemeEditorViewController
        memeEditor.meme = meme
        fromViewController.presentViewController(memeEditor, animated: true, completion: nil)
    }
}

extension Meme {
    
    //should have a default image included?
    static let defaultTopText = "MEMES BE LIKE"
    static let defaultBottomText = "MEEMEEMEE"
    
}