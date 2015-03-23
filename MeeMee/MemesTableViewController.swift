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
        // Show the Meme Editor if no memes exist on first load
        // presenting other doesn't work in viewDidLoad or before appearance
        
        if firstLoad && memes.count == 0 {
            firstLoad = false
            Meme.presentMemeEditor(nil, fromViewController: self)
        }
    }

    // MARK: - Table view data source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as UITableViewCell
        let meme = memes[indexPath.row]
        
        cell.imageView?.image = meme.memeImage
        cell.textLabel?.text = meme.topLabel
        cell.detailTextLabel?.text = meme.bottomLabel

        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        Meme.presentMemeEditor(memes[indexPath.row], fromViewController: self)
    }

}
