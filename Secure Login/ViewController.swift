//
//  ViewController.swift
//  Secure Login
//
//  Created by Naveen Vijay on 2019-06-17.
//  Copyright © 2019 Naveen Vijay. All rights reserved.
//

import UIKit
import CryptoSwift

class ViewController: UIViewController {

    @IBOutlet weak var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //save()
    }

    @IBOutlet weak var textPassword: UITextField!
    func save()
    {
        if let password = txtPassword.text
        {
            do {
                let aes = try AES(key: "passwordpassword", iv: "drowssapdrowssap") // aes128
                let ciphertext = try aes.encrypt(Array(password.utf8))
                print("real password",password, "AES128 = ",ciphertext.toHexString())
            } catch {
                print(error)
            }

        //print("real password", password, "sha 256 = ", a, "****", a.count)
        }
    }
    

    
    @IBAction func btnActionLogin(_ sender: Any) {
    save()
    }
}

