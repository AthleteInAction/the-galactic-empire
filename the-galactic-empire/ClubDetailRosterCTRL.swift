//
//  ClubDetailRosterCTRL.swift
//  the-galactic-empire
//
//  Created by grobinson on 8/17/15.
//  Copyright (c) 2015 wambl. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ClubDetailRosterCTRL: UITableViewController {
    
    var club: Club!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Loading.start()
        
        club.getRoster { (s) -> Void in
            
            if s {
                
                self.tableView.reloadData()
                
            }
            
            Loading.stop()
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let roster = club.roster {
            
            return roster.count
            
        } else {
            
            return 0
            
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! ClubDetailRosterCell
        
        let person = club.roster![indexPath.row]
        
        cell.playerNameTXT.text = person["personaName"].stringValue
        cell.gamertagTXT.text = person["playername"].stringValue
        cell.gpTXT.text = person["totalgp"].stringValue
        cell.gTXT.text = person["skgoals"].stringValue
        cell.aTXT.text = person["skassists"].stringValue
        cell.pTXT.text = person["skpoints"].stringValue
        cell.plusMinusTXT.text = person["skplusmin"].stringValue
        
        switch person["favoritePosition"].stringValue {
            case "Center":
                cell.posTXT.text = "C"
            case "Left wing":
                cell.posTXT.text = "LW"
            case "Right wing":
                cell.posTXT.text = "RW"
            case "Defensemen":
                cell.posTXT.text = "D"
            case "Goalie":
                cell.posTXT.text = "G"
            default:
                cell.posTXT.text = ""
        }
        
        if person["onlineStatus"].intValue == 1 {
            
            cell.online.on = true
            
        } else {
            
            cell.online.on = false
            
        }
        
        return cell
        
    }

}