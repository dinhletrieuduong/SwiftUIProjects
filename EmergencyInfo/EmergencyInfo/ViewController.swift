//
//  ViewController.swift
//  EmergencyInfo
//
//  Created by MacBook on 6/23/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, ImagePreviewDelegate {
    
    var contactIndex = -1;
    
    let imgPicker = UIImagePickerController()
    var pickedImage: UIImage?
    

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtAltPhone: UITextField!
    @IBOutlet weak var txtNote: UITextView!
    @IBOutlet weak var btnAvatar: UIButton!
    @IBAction func btnAvatar_Tapped(_ sender: UIButton) {
        imgPicker.allowsEditing = false
        imgPicker.sourceType = .photoLibrary
        
        present(imgPicker, animated: true, completion: nil)
    }
    
    @IBAction func btnSave_Tapped(_ sender: UIButton) {
        DB.Set(key: DB.Keys.NAME, value: txtName.text!)
        DB.Set(key: DB.Keys.ADDRESS, value: txtAddress.text!)
        DB.Set(key: DB.Keys.PHONE, value: txtPhone.text!)
        DB.Set(key: DB.Keys.ALT_PHONE, value: txtAltPhone.text!)
        DB.Set(key: DB.Keys.NOTE, value: txtNote.text)
        
        UI.alert(title: "Success", message: "Info Save!", view: self)
    }
    
    @IBAction func btnShowContact_Tapped(_ sender: UIButton) {
        contactIndex = sender.tag
        print(contactIndex)
        performSegue(withIdentifier: "SegueShowContactDetail", sender: self)
        
    }
    
    @IBAction func btnCallByPhone_Tapped(_ sender: UIButton) {
        let numberString = txtPhone.text
        UI.call(numberString: numberString!)
    }
    
    @IBAction func btnCallByAltPhone_Tapped(_ sender: UIButton) {
        let numberString = txtAltPhone.text
        UI.call(numberString: numberString!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let controls: [UITextField] = [txtName, txtAddress, txtPhone, txtAltPhone]
         
        UI.addDoneButtonForTextField(controls: controls)
        UI.addDoneButtonForTextView(textView: txtNote)
        
        imgPicker.delegate = self
        btnAvatar.layer.cornerRadius = btnAvatar.frame.width / 2
        btnAvatar.layer.borderColor = UIColor.darkGray.cgColor
        btnAvatar.layer.masksToBounds = true
        loadPersonalInfo()
        
        let filename = Phone.GetDocumentFolder().appendingPathComponent("\(DB.Keys.AVATAR).png")
        if FileManager.default.fileExists(atPath: filename.path) {
            btnAvatar.setImage(UIImage(contentsOfFile: filename.path), for: .normal)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueShowContactDetail" {
            let destination = segue.destination as! ContactDetailController
            destination.contactIndex = self.contactIndex
        }
    }
    
    func loadPersonalInfo() {
        txtName.text = DB.Get(key: DB.Keys.NAME)
        txtAddress.text = DB.Get(key: DB.Keys.ADDRESS)
        txtPhone.text = DB.Get(key: DB.Keys.PHONE)
        txtAltPhone.text = DB.Get(key: DB.Keys.ALT_PHONE)
        txtNote.text = DB.Get(key: DB.Keys.NOTE)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.pickedImage = pickImg
            dismiss(animated: true) {
                let destination = self.storyboard?.instantiateViewController(identifier: "ImagePreviewController") as! ImagePreviewController
                destination.image = self.pickedImage
                destination.delegateImagePreview = self
                self.present(destination, animated: true, completion: nil)
            }
        }
    }
    
    func didAcceptedAvatar(image: UIImage?) {
        btnAvatar.setImage(image, for: .normal)
        if let data = image!.pngData() {
            let filename = Phone.GetDocumentFolder().appendingPathComponent("\(DB.Keys.AVATAR).png")
            try? data.write(to: filename)
        }
    }
}

