//
//  CustomDatePicker.swift
//  ECT360
//
//  Created by Anupkumar on 12/04/19.
//  Copyright © 2019 Anupkumar. All rights reserved.
//

import UIKit

class CustomDatePicker: UIView {

    @IBOutlet weak var datepicker:UIDatePicker!
    
    @IBOutlet weak var total_view:UIView!
    
    @IBOutlet weak var done_btn:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    print("....custom....21")
        
         commoninit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("....custom....29")
        //fatalError("init(coder:) has not been implemented")
       // commoninit()
        
        
    }
    
    
 
    
    func commoninit(){
        print("...........34")
        
        Bundle.main.loadNibNamed("CustomDatePicker", owner: self, options: nil)
        
        addSubview(self.total_view)
        self.total_view.frame = self.bounds
        self.total_view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        self.datepicker.backgroundColor = UIColor.white
        
        
       
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        
       // dateFormatter.dateStyle = DateFormatter.Style.short
       // dateFormatter.timeStyle = DateFormatter.Style.short
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let strDate = dateFormatter.string(from: datepicker.date)
        print("strDate\(strDate)")
    }
    
    
    
}
