//
//  ViewController.swift
//  MemeMe
//
//  Created by Jovit Royeca on 1/19/16.
//  Copyright © 2016 Jovito Royeca. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var libraryButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    let themeColor = UIColor.grayColor()
    let topText = "TOP"
    let bottomText = "BOTTOM"
    
    // "Impact" font, all caps, white with a black outline
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : Float(-3.0)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.delegate = self
        topTextField.text = topText
        topTextField.textAlignment = .Center
        topTextField.borderStyle = .None
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.delegate = self
        bottomTextField.text = bottomText
        bottomTextField.textAlignment = .Center
        bottomTextField.borderStyle = .None
        
        view.backgroundColor = themeColor
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func pickAnImageFromGallery(sender: UIBarButtonItem) {
        pickAnImage(.PhotoLibrary)
    }
    
    
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        pickAnImage(.Camera)
    }
    
    func pickAnImage(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
//MARK: When the keyboardWillShow notification is received, shift the view's frame up
    func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

//MARK: When the keyboardWillHide notification is received, shift the view's frame down
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0.0
    }
    
//MARK: un/subscription to notifications
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
//Mark: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickerView.image = image
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        if let text = textField.text {
            if text.uppercaseString == topText ||
                text.uppercaseString == bottomText {
                textField.text = ""
            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let text = textField.text {
            if text.uppercaseString == "" {
                if textField == topTextField {
                    textField.text = topText
                } else if textField == bottomTextField {
                    textField.text = bottomText
                }
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

