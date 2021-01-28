//
//  ViewController.swift
//  BuildMeme
//
//  Created by Nihal Erdal on 1/26/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldButtom: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldTop.delegate = self
        textFieldButtom.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
  // 1.When the user tap the Pick button, it provide the open photo gallery(picker controller)
    @IBAction func pickAnImageFromGallery(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
      
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
      
    }
    //2.1 After opening gallery, when user select a photo :
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        guard let image = info[.originalImage] as? UIImage else {return}
        
            imagePickerView.image = image
        
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //2.2 After opening gallery, when user tap the Cancel instead of picking a photo
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    

        
    func textFieldDidBeginEditing(_ textField: UITextField){
            textField.text = ""
        }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
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
