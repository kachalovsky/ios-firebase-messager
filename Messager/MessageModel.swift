//
//  MessageModel.swift
//  Messager
//
//  Created by Andrey on 01.01.2018.
//  Copyright © 2018 bstu.fit. All rights reserved.
//

import UIKit
import Firebase

class MessageModel {
    
    init(){}
    
    init (dictionary: DataSnapshot) {
        message = dictionary.childSnapshot(forPath: "message").value as! String
        author = dictionary.childSnapshot(forPath: "author").value as! String
    }
    
    var message = ""
    var author = ""
}
