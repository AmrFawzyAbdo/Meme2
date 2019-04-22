//
//  DetailViewController.swift
//  Meme
//
//  Created by Amr on 161//19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var meme: Meme!
    
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var textLabel : UILabel!
    var index : Int!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        meme = appDelegate.memes[index]
        self.imageView.image = meme.memedImage
        self.textLabel.text = meme.topText + ".." + meme.bottomText
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(DetailViewController.callMemeEditor))
        
    }
    
    
    @objc func callMemeEditor(){
     let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        
        if (viewController.view != nil){
            viewController.topText.text = meme.topText
            viewController.bottomText.text = meme.bottomText
            viewController.imagePickerView.image = meme.originalImage
            viewController.index = index
            viewController.shareButton.isEnabled = true
            viewController.cancelButton.isEnabled = true
        }
        present(viewController, animated: true, completion: nil)
        }
    }



