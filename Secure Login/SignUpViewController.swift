//
//  SignUpViewController.swift
//  Secure Login
//
//  Created by Naveen Vijay on 2019-06-19.
//  Copyright © 2019 Naveen Vijay. All rights reserved.
//

import UIKit
import Firebase
import CryptoSwift

class SignUpViewController: UIViewController {

    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var textConfirmPassword: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        textEmail.underlined()
        textPassword.underlined()
        textConfirmPassword.underlined()
        
        textEmail.attributedPlaceholder = NSAttributedString(string: "email id", attributes: [NSAttributedString.Key.foregroundColor: UIColor.brown])
        textPassword.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.brown])
        textConfirmPassword.attributedPlaceholder = NSAttributedString(string: "email id", attributes: [NSAttributedString.Key.foregroundColor: UIColor.brown])
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    @IBAction func btnSignUp(_ sender: Any)
    {
        funcCheckValues()
    }
    
    @IBAction func btnBack(_ sender: Any)
    {
        funcTologinView()
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

extension SignUpViewController
{
    //check values
    func funcCheckValues()
    {
        if let email = textEmail.text, let password = textPassword.text, let confirmPassword = textConfirmPassword.text
        {
            if email == "" || password == "" || confirmPassword == ""
            {
                funcAlert(title: "ooops!", message: "add email id password and confirm your password")
            }
            else
            {
                if password == confirmPassword
                {
                    let passwordValid = funcIsPasswordValid(password)
                    if passwordValid == true
                    {
                        funcPasEncription(email: email, password: password)
                    }
                    else
                    {
                        funcAlert(title: "ooops!", message: "password must be 8 character length with atleast 1 upper & lower case letter. one number & a special character")
                    }
                }
                else
                {
                    funcAlert(title: "ooops!", message: "password mismatch")
                }
            }
        }
    }
    
    //password stregnth check
    func funcIsPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        //let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[$@$#!%*?&`~^-_{};:',.<>])[A-Za-z\\d$@$#!%*?&`~^-_{};:',.<>]{8,}")
        //let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8}$")
        return passwordTest.evaluate(with: password)
    }

    //encription
    func funcPasEncription(email: String, password: String)
    {
        /*var salt = ""
        var password = ""
        var email = ""
        if let pass = textPassword.text, let user = textUserName.text
        {
            if pass == "" || user == ""
            {
                funcAlert(title: "ooops!", message: "add email id and password")
                return
            }
            email = user
            password = pass
            salt = user
        }*/
        
        //background running
        DispatchQueue.global(qos: .utility).async
            {
                do
                {
                    let password: Array<UInt8> = Array(password.utf8)
                    let salt: Array<UInt8> = Array(email.utf8)
                    
                    let value = try PKCS5.PBKDF2(password: password, salt: salt, iterations: 50000, variant: .sha512).calculate()
                    let encripted = value.toHexString()
                    print("--------",value.toHexString())
                    self.funcSignUp(email: email, password: encripted)
                } catch {print("---------errr")}
        }
    }
    
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
    
    
    //go back to login view
    func funcTologinView()
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "login") as! ViewController
        self.present(nextViewController, animated:true, completion:nil)
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

//move screen when keyboard popup
extension SignUpViewController
{
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
