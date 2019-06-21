//
//  LoginViewController.swift
//  Secure Login
//
//  Created by Naveen Vijay on 2019-06-21.
//  Copyright © 2019 Naveen Vijay. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnActionLogin(_ sender: Any)
    {
        let when = DispatchTime.now() + 0.2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when)
        {
            //code with delay
            //self.viewLogin.isHidden = true
            try! Auth.auth().signOut()
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "login") as! ViewController
            self.present(nextViewController, animated:true, completion:nil)
        }
        
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
