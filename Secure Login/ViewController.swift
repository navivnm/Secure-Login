//
//  ViewController.swift
//  Secure Login
//
//  Created by Naveen Vijay on 2019-06-17.
//  Copyright © 2019 Naveen Vijay. All rights reserved.
//

import UIKit
import CryptoSwift
import Firebase

class ViewController: UIViewController {

    //var handle: AuthStateDidChangeListenerHandle?
    var loginSignup = ""

    @IBOutlet weak var textUserName: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    

    /*override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }*/
    
    @IBAction func btnActionLogin(_ sender: Any)
    {
        loginSignup = "login"
        funcPasEncription()
    }
    
    @IBAction func btnActionSignUp(_ sender: Any)
    {
        loginSignup = "signup"
        funcPasEncription()
    }
}

//functions
extension ViewController
{
    //signup
    func funcSignUp(email: String, password: String)
    {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            guard let user = authResult?.user, error == nil else
            {
                print("sign uppp errrr", error!.localizedDescription)
                self.funcAlert(title: "SignUp Failed", message: error?.localizedDescription ?? "SignUp failed please check email id is vaild")
                return
            }
            //print("\(user.email!) created")
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                if let err = error?.localizedDescription
                {
                    print("vemail fail",err)
                    self.funcAlert(title: "acoount creation failed", message: err)
                }
                else
                {
                    print("vvvv emaill send")
                    self.funcAlert(title: "account created", message: "verification email send to \(user.email!). please verify to use your account")
                }
            })
            try! Auth.auth().signOut()
        }
    }
    
    //login
    func funcLogin(email: String, password: String)
    {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in

            if let error = error
            {
                print("sign in errrrr",error.localizedDescription)
                self?.funcAlert(title: "Login Failed", message: error.localizedDescription)
                return
            }
            else
            {
                if Auth.auth().currentUser?.isEmailVerified == true
                {
                    print("logiinnnnnnnnnnn")
                }
                else
                {
                    print("verify email")
                    self?.funcAlert(title: "Caution", message: "verification email send to \(email). please verify to use your account")
                }
            }
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    //encription
    func funcPasEncription()
    {
        var salt = ""
        var password = ""
        var email = ""
        if let pass = textPassword.text, let user = textUserName.text
        {
            email = user
            password = pass
            salt = user
        }
        else
        {
            print("no text")
            return
        }
        
        do {
            let password: Array<UInt8> = Array(password.utf8)
            let salt: Array<UInt8> = Array(salt.utf8)
            
            let value = try PKCS5.PBKDF2(password: password, salt: salt, iterations: 50000, variant: .sha512).calculate()
            let encripted = value.toHexString()
            print("--------",value.toHexString())
            if loginSignup == "login"
            {
                funcLogin(email: email, password: encripted)
            }
            else
            {
                funcSignUp(email: email, password: encripted)
            }
        } catch {}
    }
    
    //alert
    func funcAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
}

