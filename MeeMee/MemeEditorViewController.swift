//
//  MemeEditorViewController.swift
//  MeeMee
//
//  Created by Nathan Allison on 3/17/15.
//  Copyright (c) 2015 shondicon. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController,
UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{

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

    var meme:Meme?

    let memeTextAttributes = [
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSStrokeWidthAttributeName: -3.0, // For stroke AND fill to show, this needs to be negative, weird
    ]


    override func viewDidLoad() {
        super.viewDidLoad()

        for label in [topLabel,bottomLabel] {
            label.delegate = self
            label.defaultTextAttributes = memeTextAttributes
            label.textAlignment = NSTextAlignment.Center
            label.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        }
        
        if let cmeme = meme {
            imageView.image = cmeme.image
            topLabel.text = cmeme.topLabel
            bottomLabel.text = cmeme.bottomLabel
        }
        else {
            resetMemeEdits()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()

        camButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)

        
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }


    // MARK: Keyboard Stuff (Subscribe to keyboard notifications and push view up if lower)

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
        if currentTextField == bottomLabel {
            self.view.frame.origin.y = 0
        }
    }

    func keyboardWillShow(notification: NSNotification){
        if currentTextField == bottomLabel {
            //if user switches keyboard while typing this gets called again so reset before offseting
            self.view.frame.origin.y = 0
            self.view.frame.origin.y -= getKeyboardHeight(notification) - toolBar.frame.height
        }
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        //TODO: take into account the toolbar at the bottom?
        let userInfo = notification.userInfo
        let kbSize = userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue
        return kbSize.CGRectValue().height
    }

    func textFieldShouldClear(textField: UITextField) -> Bool {
        // Only clear labels to edit if they are default
        if textField == topLabel && textField.text  == Meme.defaultTopText {
            return true
        }
        if textField == bottomLabel && textField.text == Meme.defaultBottomText {
            return true
        }

        return false
    }

    
    // MARK: TextFieldDelegate

    func textFieldShouldReturn(textField: UITextField) -> Bool {
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

        shareButton.enabled = false
//        cancelButton.enabled = false

        imageView.image = nil
    }


    @IBAction func cancelMemeEdits(sender: AnyObject) {
//        resetMemeEdits()
        dismissViewControllerAnimated(true, completion: nil)

    }


    // MARK: Share & Save

    func save(){
        //skip save if current state is same as current meme
        if let currentMeme = self.meme {
            //editor has a meme instance
            if currentMeme.image == imageView.image
                && currentMeme.topLabel == self.topLabel.text
                && currentMeme.bottomLabel == self.bottomLabel.text {
                    // TODO: should implement better comparison. protocol?
                    return
            }
        }
 

        let renderedMeme = renderMemeImage()

        self.meme = Meme(topLabel: topLabel.text,
            bottomLabel: bottomLabel.text,
            image: imageView.image!,
            memeImage: renderedMeme)

        // Add it to the memes array in the Application Delegate
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.memes.append(meme!)

    }

    func renderMemeImage() -> UIImage {
        /**
            Flatten the meme elements into UIImage, should this return the whole meme or just image?
            :return: The flattened UIImage with Meme text
        */
        //TODO: Look into better system for this. Move image context down or push image up???

        //hide toolbar pre-capture, this might not be necessary with proper context or other capture method
        toolBar.hidden = true

        // Render view to an image
        let contextView = view
        let contextFrame = contextView.frame
        let contextSize = contextFrame.size
//        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
//        let choppy = view.frame.height - toolBar.frame.height - statusBarHeight
//        let contextSize = CGSize(width: view.frame.size.width, height: choppy)        //just use the size of the image view ? subtract toolbar height?

        //use WithOptions to set scale multiplier to 0.0, keeps image at device resolution
        UIGraphicsBeginImageContextWithOptions(contextSize, true, CGFloat(0.0))

//        self.view.frame.origin.y += statusBarHeight

        self.view.drawViewHierarchyInRect(contextFrame, afterScreenUpdates: true)

        let renderedMemeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

//        self.view.frame.origin.y -= statusBarHeight

        toolBar.hidden = false

        return renderedMemeImage

    }


    @IBAction func saveMemeAndShare(sender: AnyObject) {
        save() // this only saves if the meme has changed
        
        // Do the sharing here for now with the flattened image
        if let shareImage = meme?.memeImage{
            let controller = UIActivityViewController(activityItems: [shareImage], applicationActivities: nil)
            
            //Use popover for iPad (otherwise this crashes on iPad)
            //http://stackoverflow.com/questions/25644054/uiactivityviewcontroller-crashing-on-ios8-ipads
            if let popupVC = controller.popoverPresentationController{
                popupVC.barButtonItem = shareButton
            }
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }



}
