//
//  MemesCollectionViewController.swift
//  MeeMee
//
//  Created by Nathan Allison on 3/19/15.
//  Copyright (c) 2015 shondicon. All rights reserved.
//

import UIKit

let reuseIdentifier = "MemeCollectionCell"

class MemesCollectionViewController: UICollectionViewController, UICollectionViewDataSource {

    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        println("GETTIN DA MEMES")
        memes = appDelegate.memes
        println("I HAZ DA MEMES: \(memes)")
        
        
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        println("Gettin cellForItemBlahBlah")
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier,
            forIndexPath: indexPath) as MemeCollectionViewCell
        
        println("GOT THE CELL? \(cell)")
        
        let meme = self.memes[indexPath.row]
        
        println("GOT THE MEME? \(meme)")
        
        cell.memeImageView.image = meme.memeImage

        return cell
    }
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        showMemeEditor(memes[indexPath.row])
    }
    
    
    func showMemeEditor(meme:Meme?) {
        var storyboard = UIStoryboard (name: "Main", bundle: nil)
        var resultVC = storyboard.instantiateViewControllerWithIdentifier("MemeEditor") as MemeEditorViewController
        resultVC.meme = meme
        self.presentViewController(resultVC, animated: true, completion: nil)
    }


}
