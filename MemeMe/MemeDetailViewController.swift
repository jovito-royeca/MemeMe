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
        let editorController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeDetailViewController
        editorController.meme = meme
        navigationController!.pushViewController(editorController, animated: true)
    }
}
