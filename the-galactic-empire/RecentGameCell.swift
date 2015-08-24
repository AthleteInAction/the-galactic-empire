//
//  RecentGameCell.swift
//  the-galactic-empire
//
//  Created by grobinson on 8/17/15.
//  Copyright (c) 2015 wambl. All rights reserved.
//

import UIKit

class RecentGameCell: UITableViewCell {
    
    var club: Club!
    var match: Match!
    
    var v: UIViewController!

    @IBOutlet weak var imgAway: UIImageView!
    @IBOutlet weak var nameAway: UILabel!
    @IBOutlet weak var shotsAway: UILabel!
    @IBOutlet weak var imgHome: UIImageView!
    @IBOutlet weak var nameHome: UILabel!
    @IBOutlet weak var shotsHome: UILabel!
    
    @IBOutlet weak var whenTXT: UILabel!
    
    @IBOutlet weak var scoreTXT: UILabel!
    
    @IBOutlet weak var statsAway: UIButton!
    @IBOutlet weak var statsHome: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        
    }
    
    @IBAction func statsClicked(sender: UIButton) {
        
        let t = sender.tag
        
        var vc = v.storyboard?.instantiateViewControllerWithIdentifier("stats_popover") as! StatsPopoverCTRL
        
        vc.club = club
        vc.match = match
        vc.id = t
        
        var nav = UINavigationController(rootViewController: vc)
        
        v.presentViewController(nav, animated: true, completion: nil)
        
    }
    
    @IBAction func teamTapped(sender: AnyObject) {
        
        var vc = v.storyboard?.instantiateViewControllerWithIdentifier("club_detail") as! ClubDetailCTRL
        
        vc.club = Club(json: nil)
        vc.club.id = match.awayID
        vc.club.name = match.awayName
        vc.club.teamID = match.awayTID
        vc.club.img = match.awayImage
        vc.getRecord()
        
        v.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
