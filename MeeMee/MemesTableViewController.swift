//
//  MemesTableViewController.swift
//  MeeMee
//
//  Created by Nathan Allison on 3/19/15.
//  Copyright (c) 2015 shondicon. All rights reserved.
//

import UIKit

class MemesTableViewController: UITableViewController, UITableViewDataSource {

    // will get this from the AppDelegate every time view will appear
    var memes: [Meme]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        memes = appDelegate.memes
    }
    
    override func viewDidAppear(animated: Bool) {
        // Show the Meme Editor if no memes exist
        // There should be a better way to handle this, I'm not sure this is the best default,
        // perhaps there should be an "Add Meme" on the tab bar, that starts a new Meme
        
        if memes.count == 0 {
            var storyboard = UIStoryboard (name: "Main", bundle: nil)
            var resultVC = storyboard.instantiateViewControllerWithIdentifier("MemeEditor") as MemeEditorViewController
            self.presentViewController(resultVC, animated: true, completion: nil)

        }
    }
    

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as UITableViewCell
        let meme = memes[indexPath.row]
        
        cell.textLabel?.text = meme.topLabel
        cell.imageView?.image = meme.memeImage
        cell.detailTextLabel?.text = meme.bottomLabel
        
        return cell
    }



}
