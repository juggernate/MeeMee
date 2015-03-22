//
//  MemesTableViewController.swift
//  MeeMee
//
//  Created by Nathan Allison on 3/19/15.
//  Copyright (c) 2015 shondicon. All rights reserved.
//

import UIKit

class MemesTableViewController: UIViewController, UITableViewDataSource {

    // will get this from the AppDelegate every time view will appear
    var memes: [Meme]!
    var firstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.memes = appDelegate.memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.memes = appDelegate.memes
    }
    
    override func viewDidAppear(animated: Bool) {
        // Show the Meme Editor if no memes exist
        // There should be a better way to handle this, I'm not sure this is the best default,
        // perhaps there should be an "Add Meme" on the tab bar, that starts a new Meme
        
        if firstLoad && memes.count == 0 {
            firstLoad = false
            Meme.presentMemeEditor(nil, fromViewController: self)
        }
    }

    // MARK: - Table view data source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("TABLE VIEW ZEZ Number of Rows: \(memes.count)")
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as UITableViewCell
        let meme = memes[indexPath.row]
        
        cell.imageView?.image = meme.image
        cell.textLabel?.text = meme.topLabel
        cell.detailTextLabel?.text = meme.bottomLabel

        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        showMemeEditor(memes[indexPath.row])
        Meme.presentMemeEditor(memes[indexPath.row], fromViewController: self)
    }
    
//    func showMemeEditor(meme:Meme?) {
//        var storyboard = UIStoryboard (name: "Main", bundle: nil)
//        var resultVC = storyboard.instantiateViewControllerWithIdentifier("MemeEditor") as MemeEditorViewController
//        resultVC.meme = meme
//        self.presentViewController(resultVC, animated: true, completion: nil)
//    }
}
