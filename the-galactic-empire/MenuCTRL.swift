//
//  MenuCTRL.swift
//  the-galactic-empire
//
//  Created by grobinson on 8/20/15.
//  Copyright (c) 2015 wambl. All rights reserved.
//

import UIKit
import Parse

class MenuCTRL: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = PFUser.currentUser()!["displayName"] as? String
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Imperial New Order"
        
    }

}