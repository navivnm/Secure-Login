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

class ViewController: UIViewController
{
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    @IBOutlet weak var textUserName: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var viewLogin: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        textUserName.underlined()
        textPassword.underlined()
        textUserName.attributedPlaceholder = NSAttributedString(string: "email id", attributes: [NSAttributedString.Key.foregroundColor: UIColor.brown])
        textPassword.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.brown])
        
        //notificationcenter for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //hide keyboard when touch outside
        self.view.endEditing(true)
    }

    
    @IBAction func btnActionLogin(_ sender: Any)
    {
        self.view.endEditing(true)
        funcActivityIndicator()
        funcPasEncription()
    }
    
    @IBAction func btnActionSignUp(_ sender: Any)
    {

    }
    
    @IBAction func btnActionLogout(_ sender: Any)
    {
        // execute after 0.2 second
        let when = DispatchTime.now() + 0.2
        DispatchQueue.main.asyncAfter(deadline: when)
        {
            //code with delay
            self.viewLogin.isHidden = true
            try! Auth.auth().signOut()
        }
    }
}

//functions
extension ViewController
{
    //login
    func funcLogin(email: String, password: String)
    {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in

            if let error = error
            {
                self?.activityIndicator.removeFromSuperview()
                print("sign in errrrr",error.localizedDescription)
                self?.funcAlert(title: "Login Failed", message: error.localizedDescription)
                return
            }
            else
            {
                if Auth.auth().currentUser?.isEmailVerified == true
                {
                    print("logiinnnnnnnnnnn")
                    //self?.viewLogin.isHidden = false
                    self?.activityIndicator.removeFromSuperview()
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "inlogin") as! LoginViewController
                    self?.present(nextViewController, animated:true, completion:nil)
                }
                else
                {
                    self?.activityIndicator.removeFromSuperview()
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
            if pass == "" || user == ""
         {
            activityIndicator.removeFromSuperview()
            funcAlert(title: "ooops!", message: "add email id and password")
            return
         }
            email = user
            password = pass
            salt = user
         }
        
        
        //background thread
        DispatchQueue.global(qos: .utility).async
        {
            do
            {
                let password: Array<UInt8> = Array(password.utf8)
                let salt: Array<UInt8> = Array(salt.utf8)
            
                let value = try Scrypt(password: password, salt: salt, dkLen: 128, N: 16384, r: 8, p: 1).calculate()
                let encripted = value.toHexString()
                print("--------",value.toHexString())
                self.funcLogin(email: email, password: encripted)
            } catch {self.activityIndicator.removeFromSuperview(); print("---------errr")}
        }
    }
    
    //activity indicator
    func funcActivityIndicator()
    {
        activityIndicator.center = self.view.center
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
    }
    
    //text field image
    /*func funcTextFieldImage()
    {
        textUserName.leftViewMode = UITextField.ViewMode.always
        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: textUserName.frame.height, height: textUserName.frame.height))
        var image = UIImage(named: "email1X.png")
        imageView.image = image
        textUserName.leftView = imageView
        
        textPassword.leftViewMode = UITextField.ViewMode.always
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: textPassword.frame.height, height: textPassword.frame.height))
        image = UIImage(named: "showpas1X.png")
        imageView.image = image
        textPassword.leftView = imageView
    }*/
    
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
extension ViewController
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
