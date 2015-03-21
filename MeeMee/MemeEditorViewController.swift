//
//  MemeEditorViewController.swift
//  MeeMee
//
//  Created by Nathan Allison on 3/17/15.
//  Copyright (c) 2015 shondicon. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController,
UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var camButton: UIBarButtonItem!
    @IBOutlet weak var topLabel: UITextField!
    @IBOutlet weak var bottomLabel: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var currentTextField: UITextField?
    
    var didBeginEditing = false
    
    let memeTextAttributes = [
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSStrokeWidthAttributeName: -3.0, // For stroke AND fill to show, this needs to be negative, wha???
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for label in [topLabel,bottomLabel]{
            label.delegate = self
            label.defaultTextAttributes = memeTextAttributes
            label.textAlignment = NSTextAlignment.Center
            label.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        }
        
        resetMemeEdits()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        camButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Keyboard Stuff
    // Subscribe to keyboard notifications and push view up if lower

    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object:nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillHideNotification, object:nil)

    }
    
    func keyboardWillHide(notification: NSNotification){
//        println("Keyboard will HIDE with NOTIFICATION:\n\(notification)")
        if currentTextField == bottomLabel{
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillShow(notification: NSNotification){
//        println("Keyboard will SHOW with NOTIFICATION:\n\(notification)")
        if currentTextField == bottomLabel{
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let kbSize = userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue
        return kbSize.CGRectValue().height
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        println("\(textField) asks Should Clear?")
        // ONLY CLEAR IF LABEL IS DEFAULT
        if textField == topLabel && textField.text  == "TOP"{
            return true
        }
        
        if textField == bottomLabel && textField.text == "BOTTOM"{
            return true
        }
        
        return false
    }
    
    
    // MARK: TextFieldDelagate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        println("\(textField) asks Should Return?")
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        currentTextField = textField
        return true
    }

    
    // MARK: ImagePickin Yeehaw
    
    @IBAction func pickImage(sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        
        if sender == camButton {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        } else {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        enableMemeEditors()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //imageView.image = nil // this will set existing to nil, probably not desired
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: Setup, reset
    
    func enableMemeEditors(){
        topLabel.enabled = true
        bottomLabel.enabled = true
        
        shareButton.enabled = true
        cancelButton.enabled = true
    }
    
    
    func resetMemeEdits(){
        topLabel.text = Meme.defaultTopText
        bottomLabel.text = Meme.defaultBottomText
        //disable the labels until image is picked?
//        topLabel.enabled = false
//        bottomLabel.enabled = false
        
        shareButton.enabled = false
        cancelButton.enabled = false
        
        imageView.image = nil
    }
    
    
    @IBAction func cancelMemeEdits(sender: AnyObject) {
//        resetMemeEdits()
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    // MARK: Share & Save
    
    func save(){
        //flatten the meme image and text
        let renderedMeme = renderMemeImage()
        
        //make the meme image, should this be a property for access in other methods?
        let meme = Meme(topLabel: topLabel.text,
            bottomLabel: bottomLabel.text,
            image: imageView.image!,
            memeImage: renderedMeme)
        
        // Add it to the memes array in the Application Delegate
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.memes.append(meme)
        
        // Do the sharing here for now with the flattened image
        let controller = UIActivityViewController(activityItems: [renderedMeme], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: nil)
        
        println("\n\(appDelegate.memes.count) Memes Total:")
        for m in appDelegate.memes{
            println("\(m.topLabel): \(m.bottomLabel)")
            println("Input Image Size: \(m.image.size)")
            println("Flattened Size: \(m.memeImage.size) ")
        }
        println("")
        
    }
    
    func renderMemeImage() -> UIImage {
        //TODO: HIDE TOOLBARS
        toolBar.hidden = true
        
        
        //need reference to toolbar?
        if let navVC = self.navigationController?.navigationController{
            println(" IN NAV VC DOOD")
        }
        
        // Render view to an image
        let contextView = view
        let contextFrame = contextView.frame
        let contextSize = contextFrame.size
        //        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
//        let choppy = view.frame.height - toolBar.frame.height - statusBarHeight
//        let contextSize = CGSize(width: view.frame.size.width, height: choppy)        //just use the size of the image view ? subtract toolbar height?
//        contextSize =

        //use WithOptions to set scale multiplier to 0.0, keeps from going fuzzy
        UIGraphicsBeginImageContextWithOptions(contextSize, true, CGFloat(0.0))
        // TODO: move the context down, or move the view UP into the context frame
//        UIGraphics
//        self.view.frame.origin.y += statusBarHeight
        
        self.view.drawViewHierarchyInRect(contextFrame, afterScreenUpdates: true)
        
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
//        self.view.frame.origin.y -= statusBarHeight
        
        //TODO: SHOW TOOLBARS
        toolBar.hidden = false
        
        return memedImage
        
    }
    
    
    @IBAction func saveMemeAndShare(sender: AnyObject) {
        save()
        
        //TODO: Activity Share sheet with content (memedImage)
        
        // return to tabView? or just change "Cancel" button to "Done" to manually dismiss?
    }
    


}
