//
//  LoginViewController.swift
//  Secure Login
//
//  Created by Naveen Vijay on 2019-06-21.
//  Copyright © 2019 Naveen Vijay. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController
{

    @IBOutlet weak var textViewPassword: UITextView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textViewPassword.text = "8 Tips to Make Your Passwords as Strong as Possible \n\n1. MAKE YOUR PASSWORD LONG.\nHackers use multiple methods for trying to get into your accounts. The most rudimentary way is to personally target you and manually type in letters, numbers, and symbols to guess your password. The more advanced method is to use what is known as a “brute force attack.” In this technique, a computer program runs through every possible combination of letters, numbers, and symbols as fast as possible to crack your password. The longer and more complex your password is, the longer this process takes. Passwords that are three characters long take less than a second to crack. \n\n2. MAKE YOUR PASSWORD A NONSENSE PHRASE. \nLong passwords are good; long passwords that include random words and phrases are better. If your letter combinations are not in the dictionary, your phrases are not in published literature, and none of it is grammatically correct, they will be harder to crack. Also do not use characters that are sequential on a keyboard such as numbers in order or the widely used “qwerty.” \n\n3. INCLUDE NUMBERS, SYMBOLS, AND UPPERCASE AND LOWERCASE LETTERS. \nRandomly mix up symbols and numbers with letters. You could substitute a zero for the letter O or @ for the letter A, for example. If your password is a phrase, consider capitalizing the first letter of each new word, which will be easier for you to remember.\n\n4. AVOID USING OBVIOUS PERSONAL INFORMATION.\nIf there is information about you that is easily discoverable—such as your birthday, anniversary, address, city of birth, high school, and relatives’ and pets’ names—do not include them in your password. These only make your password easier to guess. On that note, if you are required to choose security questions and answers when creating an online account, select ones that are not obvious to someone browsing your social media accounts.\n\n5. DO NOT REUSE PASSWORDS.\nWhen hackers complete large-scale hacks, as they have recently done with popular email servers, the lists of compromised email addresses and passwords are often leaked online. If your account is compromised and you use this email address and password combination across multiple sites, your information can be easily used to get into any of these other accounts. Use unique passwords for everything. \n\n6. START USING A PASSWORD MANAGER.\nPassword managers are services that auto-generate and store strong passwords on your behalf. These passwords are kept in an encrypted, centralized location, which you can access with a master password. (Don’t lose that one!) Many services are free to use and come with optional features such as syncing new passwords across multiple devices and auditing your password behavior to ensure you are not using the same one in too many locations. \n\n7. KEEP YOUR PASSWORD UNDER WRAPS. \nDon’t give your passwords to anyone else. Don’t type your password into your device if you are within plain sight of other people. And do not plaster your password on a sticky note on your work computer. If you’re storing a list of your passwords—or even better, a password hint sheet—on your computer in a document file, name the file something random so it isn’t a dead giveaway to snoopers. \n\n8. CHANGE YOUR PASSWORDS REGULARLY. \nThe more sensitive your information is, the more often you should change your password. Once it is changed, do not use that password again for a very long time."
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
