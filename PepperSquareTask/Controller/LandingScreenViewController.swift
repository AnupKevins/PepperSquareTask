//
//  LandingScreenViewController.swift
//  PepperSquareTask
//
//  Created by Anupkumar on 20/04/19.
//  Copyright © 2019 Anupkumar. All rights reserved.
//

import UIKit
import CoreData

class LandingScreenViewController: BaseClassViewController,to_pass_arr_images{
    
    @IBOutlet weak var table_view:UITableView!
    
    var timer = Timer()
    
    var index_of_cell = -1
    
    var presents = [[ArrayImages]]()
    
    var singlepresents = [ArrayImages]()
    
    var managedObjextContext:NSManagedObjectContext!
    
    var person = [Person]()
    
    let userdefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.table_view.estimatedRowHeight = 500
        self.table_view.rowHeight = UITableView.automaticDimension
        
        managedObjextContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        loadData()
        
        title_loadData()
        
        
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.willTerminateNotification, object: nil)
        
    }
    
    func loadData(){
        let presentRequest:NSFetchRequest<ArrayImages> = ArrayImages.fetchRequest()
        
        do {
            singlepresents = try managedObjextContext.fetch(presentRequest)
            if singlepresents.count > 0{
                presents.append(singlepresents)
            }
           // self.table_view.reloadData()
            print(".........58")
            print(presents.count)
        }catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
        
        
    }
    
    func title_loadData(){
        let personRequest:NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            person = try managedObjextContext.fetch(personRequest)
            self.table_view.reloadData()
            print("........134")
            print(person)
            //print(person.first?.images?.count)
            if let selected_timer_int = (userdefaults.value(forKey: "selected_timer")) as? Int {
            if person.count > 0{
                let indexpath = NSIndexPath.init(row:selected_timer_int, section: 0)
                let cell = self.table_view.cellForRow(at: indexpath as IndexPath) as? LandingScreenTableViewCell
                
                let seconds = userdefaults.integer(forKey: "seconds_for_selected")
                
                cell?.seconds = seconds
                startTimer(tag:selected_timer_int,cell:cell)
            }
            }
            
        }catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
        
        
    }
    func to_pass_arr_imges(presents: [[ArrayImages]],index_img:Int) {
        
        self.presents.append(presents.first!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.prefersLargeTitles = true
         NotificationCenter.default.addObserver(self, selector: #selector(timer_running_update), name:UIApplication.willTerminateNotification, object: nil)
    
    }
    
    @IBAction func add_button(sender: UIBarButtonItem) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"AddNewActivitiesViewController") as? AddNewActivitiesViewController
        vc?.add_new_activity = true
        
        vc?.presents = presents
        
        vc?.delegate = self
        
        vc?.reloadcoredatatable = { [weak self] ()  in
            ///UI chnages in main tread
            DispatchQueue.main.async {
                
                
                //self?.loadData()
                self?.title_loadData()
            }
        }
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func stoptimer(tag:Int) {
        
        timer.invalidate()
        
    }
    
    func startTimer(tag:Int,cell:LandingScreenTableViewCell?) {
        
            runTimer(tag: tag, cell: cell)
      
    }
    
    func runTimer(tag:Int,cell:LandingScreenTableViewCell?) {
        
        index_of_cell = tag
        updateTimer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        let indexpath = NSIndexPath.init(row:index_of_cell, section: 0)
        let cell = self.table_view.cellForRow(at: indexpath as IndexPath) as? LandingScreenTableViewCell
        
        cell?.seconds += 1
            
        cell?.lbl_timer.text = timeString(time: TimeInterval(cell?.seconds ?? 0))
       
        
    }
    
    func timeString(time:TimeInterval) -> String {
         let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
         return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
}

extension LandingScreenViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return person.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LandingScreenTableViewCell", for: indexPath) as? LandingScreenTableViewCell
        
        let personitem = person[indexPath.row]
        
        cell?.lbl_description.text = personitem.title
        
        cell?.lbl_type.text = personitem.descriptionactivity
        
        cell?.lbl_date.text = personitem.date
        
        cell?.lbl_no_checklist.text = "(\(personitem.checklist ?? ""))"
        
        
       if let selected_timer_int = (userdefaults.value(forKey: "selected_timer")) as? Int {
        if selected_timer_int == indexPath.row {
           index_of_cell = indexPath.row
            cell?.btn_play.setImage(UIImage.init(named: "Timer_2"), for: .normal)
        }else{
            cell?.btn_play.setImage(UIImage.init(named: "Timer_1"), for: .normal)
        }
       }else{
        cell?.btn_play.setImage(UIImage.init(named: "Timer_1"), for: .normal)
        }
        let countpresentItem = presents.first?.count
        
        let presentItem = presents[0].first
        
        if countpresentItem == 1{
            
            if let presentImage = UIImage(data: (presentItem?.image)!) {
                cell?.Member_1.image = presentImage
            }
            
            cell?.Member_2.isHidden = true
            cell?.lbl_no_member.isHidden = true
        }else if countpresentItem == 2{
            cell?.lbl_no_member.isHidden = true
            cell?.Member_2.isHidden = false
            
            if let presentImage = UIImage(data: (presentItem?.image)!) {
                cell?.Member_1.image = presentImage
            }
            let presentItem2 = presents[0][(countpresentItem ?? 0) - 1]
            
            if let presentImage = UIImage(data: (presentItem2.image)!) {
                cell?.Member_2.image = presentImage
            }
            
            
        }else if countpresentItem ?? 0 > 2{
            if let presentImage = UIImage(data: (presentItem?.image)!) {
                cell?.Member_1.image = presentImage
            }
            let presentItem2 = presents[0][(countpresentItem ?? 0) - 2]
            
            if let presentImage = UIImage(data: (presentItem2.image)!) {
                cell?.Member_2.image = presentImage
            }
            
            cell?.lbl_no_member.isHidden = false
            cell?.lbl_no_member.text = "+ \((countpresentItem ?? 0) - 2)"
        }
        
        
        if indexPath.row % 3 == 0{
            cell?.Activity_image.image = UIImage.init(named: "Logo_1")
        }else if indexPath.row % 3 == 1{
            cell?.Activity_image.image = UIImage.init(named: "Logo_2")
        }else {
            cell?.Activity_image.image = UIImage.init(named: "Logo_3")
        }
        
        
        
        cell?.btn_play.tag = indexPath.row
        
        cell?.total_view.tag = indexPath.row
        
        cell?.btn_play.addTarget(self, action: #selector(btn_play_clicked), for: .touchUpInside)
       
        return cell!
    }
   
    @objc func btn_play_clicked(sender:UIButton){
       
        
        if index_of_cell != -1 && index_of_cell != sender.tag{
            let indexpath = NSIndexPath.init(row:index_of_cell, section: 0)
            let cell = self.table_view.cellForRow(at: indexpath as IndexPath) as? LandingScreenTableViewCell
            cell?.lbl_timer.text = "00.00.00"
            cell?.seconds = 0
            userdefaults.removeObject(forKey: "selected_timer")
            cell?.isTimerRunning = false
            cell?.btn_play.setImage(UIImage.init(named: "Timer_1"), for: .normal)
            stoptimer(tag:sender.tag)
        }
 
        
        print(sender.tag)
        let indexpath = NSIndexPath.init(row:sender.tag, section: 0)
        let cell = self.table_view.cellForRow(at: indexpath as IndexPath) as? LandingScreenTableViewCell
        
        if cell?.isTimerRunning == true {
            //play
            userdefaults.removeObject(forKey: "selected_timer")
            cell?.isTimerRunning = false
            cell?.seconds = 0
            sender.setImage(UIImage.init(named: "Timer_1"), for: .normal)
            cell?.lbl_timer.text = "00.00.00"
            stoptimer(tag:sender.tag)
        } else {
            //stop
            userdefaults.set(sender.tag, forKey: "selected_timer")
            cell?.isTimerRunning = true
            sender.setImage(UIImage.init(named: "Timer_2"), for: .normal)
            startTimer(tag:sender.tag, cell: cell)
        }
       
    }
    
    @objc func timer_running_update(){
       
        let personRequest:NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            person = try managedObjextContext.fetch(personRequest)
            
            if let selected_timer_int = (userdefaults.value(forKey: "selected_timer")) as? Int {
                let indexpath = NSIndexPath.init(row:selected_timer_int, section: 0)
                let cell = self.table_view.cellForRow(at: indexpath as IndexPath) as? LandingScreenTableViewCell
                person[selected_timer_int].time = cell?.lbl_timer.text
               userdefaults.set(cell?.seconds, forKey: "seconds_for_selected")
                stoptimer(tag: selected_timer_int)
            }
        
            
            do {
                try self.managedObjextContext.save()
                
                
            }catch {
                print("Could not save data \(error.localizedDescription)")
            }
            
        }catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
        
        
    }
    
   
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            print("m button tapped")
            
            let cell = self.table_view.cellForRow(at: indexPath) as? LandingScreenTableViewCell
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"AddNewActivitiesViewController") as? AddNewActivitiesViewController
            vc?.add_new_activity = false
            if indexPath.row == 0{
                vc?.logo_img = UIImage.init(named: "Activity_Image")!
            }else{
                 vc?.logo_img = (cell?.Activity_image.image)!
            }
           
            vc?.index_to_update = indexPath.row
            vc?.delegate = self
            
            vc?.reloadcoredatatable = { [weak self] ()  in
                ///UI chnages in main tread
                DispatchQueue.main.async {
                   
                    self?.loadData()
                    self?.title_loadData()
                }
            }
            
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        edit.backgroundColor = ColorsHexCode.hexStringToUIColor(hex:"00E9AD")
        
        return [edit]
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"AddingChecklistViewController") as? AddingChecklistViewController
        
        vc?.index_of_checklist = indexPath.row
        
        vc?.reloadcoredatatable = { [weak self] ()  in
            ///UI chnages in main tread
            DispatchQueue.main.async {
                
                self?.loadData()
                self?.title_loadData()
            }
        }
        
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
  
    
}
