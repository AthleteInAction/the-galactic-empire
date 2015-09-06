//
//  ClubDetailCTRL.swift
//  the-galactic-empire
//
//  Created by grobinson on 8/17/15.
//  Copyright (c) 2015 wambl. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ClubDetailCTRL: UITableViewController {
    
    var club: Club!

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var recordTXT: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var serverTXT: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = club.name!
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90.0
        
        img.contentMode = UIViewContentMode.ScaleAspectFit
        
        if club.teamID == nil {
            
            club.getInfo { (s) -> Void in
                
                if s {
                    
                    self.club.setImage { (s2) -> Void in
                        
                        if s2 {
                            
                            self.img.image = self.club.img
                            self.serverTXT.text = "\(self.club.region) SERVERS"
                            self.loader.stopAnimating()
                            
                        }
                        
                    }
                    
                }
                
            }
            
        } else {
            
            self.serverTXT.text = "\(self.club.region) SERVERS"
            
            if club.img == nil {
                
                club.setImage { (s2) -> Void in
                    
                    if s2 {
                        
                        self.img.image = self.club.img
                        self.loader.stopAnimating()
                        
                    }
                    
                }
                
            } else {
                
                img.image = club.img
                self.loader.stopAnimating()
                
            }
            
        }
        
        if club.wins == nil {
            
            club.getStats { (s) -> Void in
                
                if s  {
                    
                    self.recordTXT.text = "\(self.club.wins!) - \(self.club.losses) - \(self.club.otl)"
                    
                }
                
            }
            
        } else {
            
            recordTXT.text = "\(club.wins!) - \(club.losses) - \(club.otl)"
            
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "seg_club_to_roster" {
            
            var vc = segue.destinationViewController as! ClubDetailRosterCTRL
            vc.club = club
            
        }
        
        if segue.identifier == "seg_club_to_recent" {
            
            var vc = segue.destinationViewController as! ClubDetailRecentCTRL
            vc.club = club
            
        }
        
    }

}