//
//  ViewController.swift
//  Messager
//
//  Created by Andrey on 01.12.2017.
//  Copyright © 2018 bstu.fit. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onSignUp(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) {user, error in
            if let errorText = error?.localizedDescription {
                let alert = UIAlertController(title: "Registration error", message: errorText, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                UserDefaults.standard.set(user!.email!, forKey: "current_email")
                self.openChatScreen()
            }
        }
    }
    
    @IBAction func onLogIn(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) {user, error in
            if let errorText = error?.localizedDescription {
                let alert = UIAlertController(title: "Auth error", message: errorText, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                UserDefaults.standard.set(user!.email!, forKey: "current_email")
                self.openChatScreen()
            }
        }
    }
    
    func openChatScreen() {
        if let chatStoryboard = storyboard?.instantiateViewController(withIdentifier: "chatView") as? UIViewController {
            present(chatStoryboard, animated: true, completion: nil)
        }
        
    }
    
}


extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

