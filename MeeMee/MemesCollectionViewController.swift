//
//  MemesCollectionViewController.swift
//  MeeMee
//
//  Created by Nathan Allison on 3/19/15.
//  Copyright (c) 2015 shondicon. All rights reserved.
//

import UIKit

let reuseIdentifier = "MemeCollectionCell"

class MemesCollectionViewController: UIViewController, UICollectionViewDataSource {

    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.memes = appDelegate.memes
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.memes = appDelegate.memes
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // this happens BEFORE view will appear, so memes will be nil if you don't get it from AD before this
        return memes.count
        
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        println("Gettin cellForItemBlahBlah")
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier,
            forIndexPath: indexPath) as MemeCollectionViewCell
        
        println("GOT THE CELL? \(cell)")
        
        let meme = self.memes[indexPath.row]
        
        println("GOT THE MEME? \(meme)")
        
        cell.memeImageView.image = meme.memeImage

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        showMemeEditor(memes[indexPath.row])
    }
    
    func showMemeEditor(meme:Meme?) {
        var storyboard = UIStoryboard (name: "Main", bundle: nil)
        var resultVC = storyboard.instantiateViewControllerWithIdentifier("MemeEditor") as MemeEditorViewController
        resultVC.meme = meme
        self.presentViewController(resultVC, animated: true, completion: nil)
    }

}
