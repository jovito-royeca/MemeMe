//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Jovit Royeca on 1/22/16.
//  Copyright © 2016 Jovito Royeca. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var meme:Meme!
    var memeIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadMeme:", name: "memeWasUpdated", object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "memeWasUpdated", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.hidden = true
        imageView!.image = meme.memedImage
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.hidden = false
        
    }

    @IBAction func editMeme(sender: UIBarButtonItem) {
        let editorController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        editorController.meme = meme
        editorController.memeIndex = memeIndex
        navigationController!.presentViewController(editorController, animated: true, completion: nil)
    }
    
    func reloadMeme(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let topText = userInfo["topText"] {
                meme.topText = topText as? String
            }
            if let bottomText = userInfo["bottomText"] {
                meme.bottomText = bottomText as? String
            }
            if let image = userInfo["image"] {
                meme.image = image as? UIImage
            }
            if let memedImage = userInfo["memedImage"] {
                meme.memedImage = memedImage as? UIImage
                imageView!.image = meme.memedImage
            }
        }
    }
}
