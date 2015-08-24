//
//  MessageCell.swift
//  the-galactic-empire
//
//  Created by grobinson on 8/21/15.
//  Copyright (c) 2015 wambl. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageTXT: UITextView!
    @IBOutlet weak var authorTXT: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageTXT.layer.cornerRadius = 6
        messageTXT.scrollEnabled = false
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        
    }

}
