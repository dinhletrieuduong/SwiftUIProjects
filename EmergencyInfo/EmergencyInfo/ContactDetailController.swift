//
//  ContactDetailController.swift
//  EmergencyInfo
//
//  Created by MacBook on 6/27/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

import UIKit

class ContactDetailController: UIViewController {
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtAltPhone: UITextField!
    @IBOutlet weak var txtNote: UITextView!
    
    @IBAction func btnSave_Tapped(_ sender: UIButton) {
        DB.Set(key: "\(DB.Keys.NAME)\(contactIndex)", value: txtName.text!)
        
        
        UI.alert(title: "Success", message: "Info Saved!", view: self)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func btnBack_Tapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    var contactIndex: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        let controls: [UITextField] = [txtName, txtAddress, txtPhone, txtAltPhone]
         
        UI.addDoneButtonForTextField(controls: controls)
        UI.addDoneButtonForTextView(textView: txtNote)
        
        txtName.text = DB.Get(key: "\(DB.Keys.NAME)\(contactIndex)")
    }
}
