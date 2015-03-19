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
    
    var currentTextField: UITextField?
    
    var didStartEditing = false
    
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
        println("Keyboard will HIDE with NOTIFICATION:\n\(notification)")
        if currentTextField == bottomLabel{
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillShow(notification: NSNotification){
        println("Keyboard will SHOW with NOTIFICATION:\n\(notification)")
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        imageView.image = nil
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func resetMemeEdits(){
        //TODO: reset buttons to
    }
    
    


}
