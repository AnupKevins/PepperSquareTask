//
//  AddingChecklistTableViewCell.swift
//  PepperSquareTask
//
//  Created by Anupkumar on 20/04/19.
//  Copyright © 2019 Anupkumar. All rights reserved.
//

import UIKit

class AddingChecklistTableViewCell: UITableViewCell {

    @IBOutlet weak var btn_checked: UIButton!
    
    @IBOutlet weak var lbl_index: UILabel!
    
    
    @IBOutlet weak var lbl_item: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
