//
//  Helper.swift
//  EmergencyInfo
//
//  Created by MacBook on 6/26/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

import UIKit

class UI {
    static func alert(title: String, message: String, view: UIViewController) {
        let okAction = UIAlertAction(title: "Oke", style: .default, handler: nil)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(okAction);
        view.present(alert, animated: true, completion: nil)
    }
    
    static func call(numberString: String) {
        UIApplication.shared.openURL(NSURL(string: "tel://\(numberString)") as! URL)
    }
    
    static func addDoneButtonForTextField(controls: [UITextField]) {
        for control in controls {
            let toolbar = UIToolbar();
            toolbar.items = [
                UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
                UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: control, action: #selector(UITextField.resignFirstResponder))
            ]
            toolbar.sizeToFit();
            control.inputAccessoryView = toolbar;
        }
    }
    static func addDoneButtonForTextView(textView: UITextView) {
        let toolbar = UIToolbar();
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: textView, action: #selector(UITextView.resignFirstResponder))
        ]
        toolbar.sizeToFit();
        textView.inputAccessoryView = toolbar;
    }

}

class DB {
    class Keys {
        static var NAME = "NAME"
        static var ADDRESS = "ADDRESS"
        static var PHONE = "PHONE"
        static var ALT_PHONE = "ALT_PHONE"
        static var NOTE = "NOTE"
        static var AVATAR = "AVATAR"
    }
    
    static func Set(key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    static func Get(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
}

class Phone {
    static func GetDocumentFolder() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
