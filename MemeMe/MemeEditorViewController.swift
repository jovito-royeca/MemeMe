//
//  ViewController.swift
//  MemeMe
//
//  Created by Jovit Royeca on 1/19/16.
//  Copyright © 2016 Jovito Royeca. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

//MARK: UI outlets
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var libraryButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var memeView: UIView!
//MARK: --
    
    let topText = "TOP"
    let bottomText = "BOTTOM"
    let memeFontKey = "memeFont"
    let defaultFont = "HelveticaNeue-CondensedBlack"
    var currentFont:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // load previously saved font, else use the default font
        if let memeFont = NSUserDefaults.standardUserDefaults().valueForKey(memeFontKey) {
            currentFont = memeFont as? String
        } else {
            currentFont = defaultFont
        }
        
        setupTextField(topTextField, text: topText, font: currentFont!)
        setupTextField(bottomTextField, text: bottomText, font: currentFont!)
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

    func setupTextField(textField: UITextField, text: String, font: String) {
        customizeTextField(textField, withFont: font)
        textField.delegate = self
        textField.text = text
        textField.borderStyle = .None
    }
    
    func customizeTextField(textField: UITextField, withFont font: String) {
        let textAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: font, size: 40)!,
            NSStrokeWidthAttributeName : Float(-3.0)
        ]
        textField.defaultTextAttributes = textAttributes
        textField.textAlignment = .Center
        
        currentFont = font
    }
    
    func pickAnImage(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func save(memedImage: UIImage) {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image!, memedImage: memedImage)
        print("meme=\(meme)")
    }
    
    func generateMemedImage() -> UIImage {
        // Render memeView to an image
        UIGraphicsBeginImageContext(memeView.frame.size)
        memeView.drawViewHierarchyInRect(memeView.bounds, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
//MARK: Button actions
    @IBAction func pickAnImageFromGallery(sender: UIBarButtonItem) {
        pickAnImage(.PhotoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        pickAnImage(.Camera)
    }
    
    @IBAction func doAction(sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        
        let objectsToShare = [memedImage]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.completionWithItemsHandler = { activity, success, items, error in
            if error != nil {
                self.save(memedImage)
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        presentViewController(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme(sender: UIBarButtonItem) {
        actionButton.enabled = false
        cancelButton.enabled = false
        imagePickerView.image = nil
        topTextField.text = topText
        bottomTextField.text = bottomText
    }

    
    @IBAction func changeFont(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Change Font", message: nil, preferredStyle: .ActionSheet)
        var fonts = UIFont.familyNames().sort()
        fonts.insert(defaultFont, atIndex: 0)
        
        for font in fonts {
            // add a checkmark for the current font using Unicode
            let title = font == currentFont ? "\u{2713} \(currentFont!)" : font
            
            // when the user selects a font, change the font in the text fields and save the font selected
            let handler = {(alert: UIAlertAction!) in
                self.currentFont = font
                self.customizeTextField(self.topTextField, withFont: font)
                self.customizeTextField(self.bottomTextField, withFont: font)
                NSUserDefaults.standardUserDefaults().setValue(self.currentFont, forKey: self.memeFontKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
            alert.addAction(UIAlertAction(title: title, style: UIAlertActionStyle.Default, handler: handler))
        }
        presentViewController(alert, animated: true, completion: nil)
    }
    
//MARK: Keyboard
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y = 0.0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
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
            imagePickerView.image = image
            imagePickerView.contentMode = .ScaleAspectFit
            actionButton.enabled = true
            cancelButton.enabled = true
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
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
            
            } else {
                // always capitalize the text
                textField.text = text.uppercaseString
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

