//
//  Custom_top_nav_bar.swift
//  PepperSquareTask
//
//  Created by Anupkumar on 20/04/19.
//  Copyright © 2019 Anupkumar. All rights reserved.
//

import Foundation
import UIKit

class CustomAddItem: UIView {
    
    @IBOutlet weak var total_view:UIView!
    
    @IBOutlet weak var all_white_view:UIView!
    
    @IBOutlet weak var lbl_title:UILabel!
    
    @IBOutlet weak var txt_field:UITextField!
    
    @IBOutlet weak var view_submit:UIView!
    
     @IBOutlet weak var close_btn:UIButton!
    
    override init(frame:CGRect){
        super.init(frame: frame)
        print("........21")
        commoninit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("........29")
        
    }
    
    func commoninit(){
        print("...........34")
        Bundle.main.loadNibNamed("CustomAddItem", owner: self, options: nil)
        addSubview(self.total_view)
        
        self.total_view.frame = self.bounds
        
        
        self.total_view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
    }
}
struct System {
    static func clearNavigationBar(forBar navBar: UINavigationBar) {
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
    }
}
