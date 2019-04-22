//
//  MemeEditorViewController.swift
//  Meme
//
//  Created by Amr on 61//19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var pickButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var shareButton : UIBarButtonItem!
    var memedImage : UIImage!
    var index = -1
    
    let memeTextAttributes = [
        NSAttributedString.Key.strokeColor.rawValue : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth : -4.0
        ] as [AnyHashable : Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ownTextField(textField: topText)
        ownTextField(textField: bottomText)
    }
    
    func ownTextField(textField: UITextField) {
        textField.defaultTextAttributes = memeTextAttributes as! [NSAttributedString.Key : Any]
        
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        textField.textAlignment = .center
        textField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // When a user taps inside a textfield, the default text should clear.
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            textField.text = ""
        }
    }
    

    @IBAction func chooseAnImage(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        if sender.tag == 0 {
            imagePicker.sourceType = .photoLibrary
        }else {
            imagePicker.sourceType = .camera
        }
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController,                                        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.contentMode = .scaleAspectFit
            shareButton.isEnabled = true
            imagePickerView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // When a user presses return, the keyboard should be dismissed
        textField.resignFirstResponder()
        return true
    }
    
    
    @objc func keyboardWillShow(_ notification:Notification){
        
        if bottomText.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if bottomText.isFirstResponder {
            print("keyboardWillHide BT")
            view.frame.origin.y = 0
        }
    }
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func generateMemedImage() -> UIImage {

        
        //Hide Toolbar And Navigation Bar
        navigationBar.isHidden = true
        toolBar.isHidden = true
        
        // Render View To An Image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Show Toolbar and Navigation Bar
        navigationBar.isHidden = false
        toolBar.isHidden = false
        
        return memedImage
    }
    
//
//    struct Meme {
//        var top: String = ""
//        var bottom: String = ""
//        var image: UIImage?
//        var memedImage: UIImage?
//    }
    
    func save() {
        // Create The Meme
        let memedImage = generateMemedImage()
        
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if index == -1{
            appDelegate.memes.append(meme)
        }else{
            appDelegate.memes[index] = meme
        }
        
    }
        
        
    @IBAction func shareButtonAction(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = { activity, success, items, error in
            if success{
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(activityController, animated: true, completion: nil)
    }
    @IBAction func cancelButtonAction(_ sender: Any) {
        //self.dismissViewControllerAnimated(true, completion: nil)
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        self.imagePickerView.image = nil
    }
    
}
