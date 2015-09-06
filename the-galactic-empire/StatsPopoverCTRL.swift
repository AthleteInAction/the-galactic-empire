//
//  StatsPopoverCTRL.swift
//  the-galactic-empire
//
//  Created by grobinson on 8/17/15.
//  Copyright (c) 2015 wambl. All rights reserved.
//

import UIKit
import SwiftyJSON

class StatsPopoverCTRL: UITableViewController {
    
    var club: Club!
    var id: Int!
    var match: Match!
    
    var players: [JSON] = []
    
    var pos: [String] = [
        "blank",
        "RD",
        "LD",
        "LW",
        "C",
        "RW",
        "G",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let t = match.body["clubs"]["\(id)"]["details"]["name"].stringValue
        
        self.title = t
        
        if match.awayPlayers == nil {
            
            club.getRecent({ (s) -> Void in
                
                if s {
                    
                    self.setPlayers()
                    
                }
                
            })
            
        } else {
            
            self.setPlayers()
            
        }
        
        self.tableView.reloadData()
        
    }
    
    func setPlayers(){
        
        if self.match.home.id == self.id {
            
            self.players = self.match.homePlayers!
            
        } else {
            
            self.players = self.match.awayPlayers!
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if id == match.home.id {
            
            return "vs \(match.away.name!)"
            
        } else {
            
            return "vs \(match.home.name!)"
            
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return players.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! StatsPopoverCell
        
        let player = players[indexPath.row]
        
        cell.playerName.text = player["details"]["personaName"].stringValue
        cell.pTXT.text = player["skpoints"].stringValue
        cell.gTXT.text = player["skgoals"].stringValue
        cell.aTXT.text = player["skassists"].stringValue
        cell.plusMinus.text = player["skplusmin"].stringValue
        cell.sTXT.text = player["skshots"].stringValue
        cell.hTXT.text = player["skhits"].stringValue
        let pim = player["skpim"].stringValue
        cell.pimTXT.text = "\(pim):00"
        cell.posTXT.text = pos[player["position"].stringValue.toInt()!]
        
        return cell
        
    }
    
    @IBAction func cancelClicked(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

}