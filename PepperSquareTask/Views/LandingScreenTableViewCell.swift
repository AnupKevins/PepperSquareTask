//
//  LandingScreenTableViewCell.swift
//  PepperSquareTask
//
//  Created by Anupkumar on 20/04/19.
//  Copyright © 2019 Anupkumar. All rights reserved.
//

import UIKit

class LandingScreenTableViewCell: UITableViewCell {
    @IBOutlet weak var total_view: UIView!
    
    @IBOutlet weak var Activity_image: UIImageView!
    
     @IBOutlet weak var trailing_total_view: NSLayoutConstraint!
    
    @IBOutlet weak var Member_1: UIImageView!{
        
            didSet{
                Member_1.layer.borderColor = UIColor.white.cgColor
                Member_1.layer.borderWidth = 1
               
            }
        
    }
    
    @IBOutlet weak var Member_2: UIImageView!{
    didSet{
   
        Member_2.layer.borderColor = UIColor.white.cgColor
        Member_2.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var lbl_date: UILabel!
    
    @IBOutlet weak var lbl_no_member: UILabel!
    
    @IBOutlet weak var lbl_description: UILabel!
    
    @IBOutlet weak var lbl_type: UILabel!
    
    @IBOutlet weak var img_checklist: UIImageView!
    
    @IBOutlet weak var lbl_no_checklist: UILabel!

    @IBOutlet weak var btn_play: UIButton!
    
    @IBOutlet weak var lbl_timer: UILabel!
    
    var seconds = 0
    
    var isTimerRunning = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
