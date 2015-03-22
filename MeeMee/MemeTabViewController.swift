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
//        self.delegate = self
        delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        //if item matches dummy, modal view to meme editor and return false
//        let isModalTab = viewController.title == "MODAL"
//        println("\(viewController) IS MODAL TAB: \(isModalTab)")
        if viewController.title == "MODAL"{
            showMemeEditor(nil)
            return false
        }
        return true
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        println("Selected Item: \(item)")
    }
    
    func showMemeEditor(meme:Meme?) {
        var storyboard = UIStoryboard (name: "Main", bundle: nil)
        var resultVC = storyboard.instantiateViewControllerWithIdentifier("MemeEditor") as MemeEditorViewController
        resultVC.meme = meme
        self.presentViewController(resultVC, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
