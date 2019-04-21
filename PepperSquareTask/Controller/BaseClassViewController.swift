//
//  BaseClassViewController.swift
//  PepperSquareTask
//
//  Created by Anupkumar on 20/04/19.
//  Copyright © 2019 Anupkumar. All rights reserved.
//

import UIKit

class BaseClassViewController: UIViewController {
    
    let custom_date_picker: CustomDatePicker = {
        let date_picker = CustomDatePicker()
        date_picker.translatesAutoresizingMaskIntoConstraints = false
        
        return date_picker
    }()
    
    var reloadpicker = {() -> () in }
    
    var picked_date = ""
    
    let dateformatter = DateFormatter()
    
    var date_format = "dd MMM yyyy"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateformatter.dateFormat = date_format

        // Do any additional setup after loading the view.
    }
    
    func to_add_date_picker(){
        
        self.view.addSubview(custom_date_picker)
        
        
        custom_date_picker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        custom_date_picker.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        custom_date_picker.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        custom_date_picker.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
        
        self.view.bringSubviewToFront(self.custom_date_picker)
        
        let date = Date()
        
        
        let today = dateformatter.string(from: date)
        
        if let day_of_today = Date().dayOfWeek(){
        
        picked_date =  day_of_today.prefix(3) + ", " + today
        }else{
           picked_date =  today
        }
        custom_date_picker.datepicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControl.Event.valueChanged)
        custom_date_picker.done_btn.addTarget(self, action: #selector(doneactiondatepicker), for: .touchUpInside)
    }
    
    
    @objc func doneactiondatepicker(){
        
        custom_date_picker.removeFromSuperview()
        reloadpicker()
    }
    
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        
       
        if let day_of_today = sender.date.dayOfWeek(){
            
            picked_date =  day_of_today.prefix(3) + ", " + dateformatter.string(from: sender.date)
        }else{
            picked_date =  dateformatter.string(from: sender.date)
        }

        
        
    }
    
    func today_date()->String{
        let date = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = date_format
        let today = dateformatter.string(from: date)
        return today
    }
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = date_format
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    
    
    func to_add_attributes_strict_line(str:String)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: str)
        
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
        
        return attributedString
    }

    func container_custom_class_view(custom_class_view:UIView,container_view:UIView)   {
        
        print("activity_indicator_start")
        
        custom_class_view.backgroundColor = UIColor(red:68/255, green: 68/255, blue: 68/255, alpha: 0.7)
        
        
        custom_class_view.translatesAutoresizingMaskIntoConstraints = false
        
        
        container_view.addSubview(custom_class_view)
        
        custom_class_view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        custom_class_view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        custom_class_view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        custom_class_view.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
        
        container_view.bringSubviewToFront(custom_class_view)
        
        showAnimate(view_set: custom_class_view)
        
    }
    
    func showAnimate(view_set:UIView)
    {
        view_set.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 5.0, options: UIView.AnimationOptions.curveLinear, animations: {
            
            view_set.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    }
    
}
