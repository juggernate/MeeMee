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
    
    let memeTextAttributes = [
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeColorAttributeName: UIColor.blackColor(),//TODO: Fill in appropriate UIColor,
        NSForegroundColorAttributeName: UIColor.whiteColor(),//TODO: Fill in UIColor,
        //TODO: Fill in appropriate Float
        NSStrokeWidthAttributeName: -3.0,
//        NSTextAlignment: NSTextAlignment(NSTextAlignment.Center)
        
        
//        textAlignment: NSTextAlignment.Center
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        camButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        // Do any additional setup after loading the view.
        
        for label in [topLabel,bottomLabel]{
            label.delegate = self
            label.defaultTextAttributes = memeTextAttributes
            label.textAlignment = NSTextAlignment.Center
            label.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
            
            //            label.
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        camButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeToKeyboardNotifications()
//        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }

    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object:nil)
    }
    
    func keyboardWillShow(notification: NSNotification){
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let kbSize = userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue
        return kbSize.CGRectValue().height
    }
    
//    func subscribeToKeyboardNotifications(
    
    
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
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
//        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
//            imageView.image = image
//        }
//    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        imageView.image = nil
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        //TODO: check if text is default or not, how? need to identify each field and its default
        println("\(textField) asks Should Clear?")
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        println("\(textField) asks Should Return?")
        textField.resignFirstResponder()
        return true
    }
    
//    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
//        println("\(textField) asks Should End Editing?")
//        textField.resignFirstResponder()
//        return true
//    }
    
    



}
