//
//  ChatViewController.swift
//  Messager
//
//  Created by Andrey on 01.01.2018.
//  Copyright © 2018 bstu.fit. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    
    var messages = [MessageModel]()
    
    var handler: ((DataSnapshot) -> Void)!

    @IBAction func onLogOut(_ sender: Any) {
        try! Auth.auth().signOut()
        openMainScreen()
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        self.view.frame.origin.y = -keyboardFrame.height // Move view 150 points upward
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var databaseRef:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        databaseRef = Database.database().reference().child("messages")
        handler = { snapshot in
            print(snapshot)
            var loadedMessages = [MessageModel]()
            for child in snapshot.children  {
                if let messageDict = child as? DataSnapshot {
                      loadedMessages.append(MessageModel(dictionary: messageDict))
                }
            }
            self.messages = loadedMessages
            self.tableView.reloadData()
            if ( self.messages.count > 0) {
                 self.tableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
        setUpMessagesListener()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setUpMessagesListener() {
        databaseRef.observe(DataEventType.value, with: handler)
        //databaseRef.observe(DataEventType.childAdded, with: handler)
    }
    
    @IBAction func onSend(_ sender: Any) {
        let key = databaseRef.childByAutoId().key
        databaseRef.child(key).setValue(["message": messageField.text, "author": Auth.auth().currentUser?.email, "order": Date().timeIntervalSince1970])
        messageField.text = nil
    }
    
    func openMainScreen() {
        if let chatStoryboard = storyboard?.instantiateViewController(withIdentifier: "authView") as? UIViewController {
            present(chatStoryboard, animated: true, completion: nil)
        }
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if Auth.auth().currentUser?.email == message.author {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ownerMessageCell") as? MessageTableViewCell {
                cell.message = message
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "otherMessageCell") as? MessageTableViewCell {
                cell.message = message
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
