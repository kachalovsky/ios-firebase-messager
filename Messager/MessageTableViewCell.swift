//
//  MessageTableViewCell.swift
//  Messager
//
//  Created by Andrey on 01.01.2018.
//  Copyright © 2018 bstu.fit. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var authorField: UILabel!
    
    @IBOutlet weak var messageField: UILabel!
    
    var message: MessageModel? {
        didSet {
            if let mess = message {
                authorField.text = mess.author
                messageField.text = mess.message
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
