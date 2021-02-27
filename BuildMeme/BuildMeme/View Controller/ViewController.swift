//
//  ViewController.swift
//  BuildMeme
//
//  Created by Nihal Erdal on 1/26/21.
//

import UIKit

var meme: Meme?

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField(tf: textFieldTop, text: "TOP")
        setupTextField(tf: textFieldBottom, text: "BOTTOM")
    }
    
    
    func setupTextField(tf: UITextField, text: String) {
        tf.defaultTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.strokeColor : UIColor.black,
            NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -4.0,
        ]
        tf.textColor = UIColor.white
        tf.tintColor = UIColor.white
        tf.textAlignment = .center
        tf.text = text
        tf.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false
        
        //**1** Sign up to be notified when the keyboard appears
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    // 1.When the user tap the button, it provides to open either photo gallery or camera (picker controller)
    func chooseImageFromCameraOrPhoto(source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func chooseFromCamera(_ sender: Any) {
        chooseImageFromCameraOrPhoto(source: .camera)
    }
    
    
    @IBAction func chooseFromAlbum(_ sender: Any) {
        chooseImageFromCameraOrPhoto(source: .photoLibrary)
    }
    //2.1 After opening gallery, when user select a photo :
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        guard let image = info[.originalImage] as? UIImage else {return}
        
        imagePickerView.image = image
        
        shareButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //2.2 After opening gallery, when user tap the Cancel instead of picking a photo
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
        if textField.text == "TOP" || textField.text == "BOTTOM" { //-> to clear for the first time only.
            textField.text = ""
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    //**2**
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    //**3** When the keyboardWillShow notification is received, shift the view's frame up
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if textFieldBottom.isEditing { //-> only for buttom text
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
    }
    
    func save (){
        
        guard let textTop = textFieldTop.text else {return}
        guard let textBottom = textFieldBottom.text else {return}
        guard let image = imagePickerView.image else {return}
        
        
        let meme = Meme(textTop: textTop, textBottom: textBottom, image: image, memed: generateMemedImage() )
        
        
        //for sharing data -> to add to AppDelegate
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        guard let appDelegate = object as? AppDelegate else {return}
        appDelegate.memes.append(meme)
        
    }
    
    @objc func generateMemedImage() -> UIImage {
        
        navigationBar.isHidden = true
        toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()! //--how can i unwrapp this?
        UIGraphicsEndImageContext()
        
        
        navigationBar.isHidden = false
        toolBar.isHidden = false
        
        return memedImage
        
        
    }
    
    @IBAction func share(_ sender: Any) {
        
        let sharedMemedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [sharedMemedImage], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        
        activityController.completionWithItemsHandler = {(activity, success, items, error) in
            if (success) {
                self.save()
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        shareButton.isEnabled = false
        imagePickerView.image = nil
        textFieldTop.text = "TOP"
        textFieldBottom.text = "BOTTOM"
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
