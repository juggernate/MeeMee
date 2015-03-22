//
//  MemeTabViewController.swift
//  MeeMee
//
//  Created by Nathan Allison on 3/22/15.
//  Copyright (c) 2015 shondicon. All rights reserved.
//

import UIKit

class MemeTabViewController: UITabBarController, UITabBarControllerDelegate
{
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        // present the modal meme editor if dummy tab viewController is selected
        if viewController.title == "MODAL"{
            Meme.presentMemeEditor(nil, fromViewController: self)
            return false
        }
        return true
    }


}
