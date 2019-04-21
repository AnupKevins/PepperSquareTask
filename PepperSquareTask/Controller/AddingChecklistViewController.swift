//
//  AddingChecklistViewController.swift
//  PepperSquareTask
//
//  Created by Anupkumar on 20/04/19.
//  Copyright © 2019 Anupkumar. All rights reserved.
//

import UIKit
import CoreData


class AddingChecklistViewController: BaseClassViewController,UITextFieldDelegate {
    
    @IBOutlet weak var table_view:UITableView!
    
    
    @IBOutlet weak var lbl_checklist: UILabel!
    
    @IBOutlet weak var lbl_design: UILabel!
    
    @IBOutlet weak var lbl_checklist_count: UILabel!
    
    
    @IBOutlet weak var view_add_item: UIView!
    
    
    @IBOutlet weak var btn_add_item: UIButton!
    
    @IBOutlet weak var lbl_add_item: UILabel!
    
    @IBOutlet weak var hieght_table_view:NSLayoutConstraint!
    
    
    var custom_class_view = CustomAddItem()
    
    var checklists = [Checklist]()
    
    var managedObjextContext:NSManagedObjectContext!
    
    var index_of_checklist = 0
    
    var reloadcoredatatable = {() -> () in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.table_view.estimatedRowHeight = 500
        self.table_view.rowHeight = UITableView.automaticDimension
        
        //hieght_table_view = hieght_table_view.setMultiplier(multiplier:0.0)

        // Do any additional setup after loading the view.
        to_design_txtfield()
        
        view_add_item.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.view_add_item_clicked)))
        
        managedObjextContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        loadData()
     
    }
    
    func loadData(){
        let checklistRequest:NSFetchRequest<Checklist> = Checklist.fetchRequest()
        
        do {
            checklists = try managedObjextContext.fetch(checklistRequest)
            self.table_view.reloadData()
        }catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
       let selected_checklist = checklists.filter({$0.isselected == true}).count
        
        self.lbl_checklist_count.text = "(\(selected_checklist)/\(self.checklists.count))"
        
        hieght_table_view.constant = CGFloat(60 * (self.checklists.count))
        print(".......78")
        print(hieght_table_view.constant)
        if hieght_table_view.constant > (self.view.frame.height - 300){
            hieght_table_view.constant = (self.view.frame.height - 300)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        reloadcoredatatable()
    }
    
    
    @objc func view_add_item_clicked(){
        container_custom_class_view(custom_class_view:custom_class_view,container_view:self.view)
        
            custom_class_view.view_submit.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.view_submit_clicked)))
        
            custom_class_view.close_btn.addTarget(self, action: #selector(close_btn_clicked), for: .touchUpInside)
        
        
            self.custom_class_view.txt_field.becomeFirstResponder()
    }
    
    @objc func close_btn_clicked(){
        self.custom_class_view.removeFromSuperview()
        self.custom_class_view.txt_field.text = ""
    }
    
    @objc func view_submit_clicked(){
        
        if self.custom_class_view.txt_field.text?.isEmpty == true{
            to_add_msg(str:"Please enter item")
        }else{
        
        let checklist = Checklist(context: managedObjextContext)
        
        checklist.name = self.custom_class_view.txt_field.text
        checklist.isselected = false
        
        checklist.id = Int16(self.checklists.count)
        do {
            try self.managedObjextContext.save()
            
            self.custom_class_view.removeFromSuperview()
            self.custom_class_view.txt_field.text = ""
             self.loadData()
        }catch {
            print("Could not save data \(error.localizedDescription)")
        }
        }
    }
    
    func to_add_msg(str:String){
        let alert = UIAlertController.init(title: "", message: str, preferredStyle: .alert)
        
        
        let action_no = UIAlertAction.init(title: "Ok", style: .default , handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
            
            
        })
        
        
        
        alert.addAction(action_no)
        
        present(alert, animated: true, completion: nil)
    }
    
    func to_design_txtfield(){
        self.custom_class_view.txt_field.delegate = self
        self.custom_class_view.txt_field.returnKeyType = .done
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.custom_class_view.txt_field.resignFirstResponder()
        
        return true
    }

}

extension AddingChecklistViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddingChecklistTableViewCell", for: indexPath) as? AddingChecklistTableViewCell
        
        cell?.lbl_index.text = "\(indexPath.row + 1)."
       
        if checklists[indexPath.row].isselected == true{
            cell?.btn_checked.isSelected = true
            cell?.lbl_item.attributedText =  to_add_attributes_strict_line(str:checklists[indexPath.row].name ?? "")
            
            
        }else{
            cell?.btn_checked.isSelected = false
            cell?.lbl_item.text =  checklists[indexPath.row].name
        }
        
        
        
        return cell!
}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if checklists[indexPath.row].isselected == true{
            checklists[indexPath.row].isselected = false
            
        }else{
            checklists[indexPath.row].isselected = true
        }
        
        self.table_view.reloadRows(at: [indexPath], with: .automatic)
        
        do {
            try self.managedObjextContext.save()
            title_loadData(tag:indexPath.row)
            
        }catch {
            print("Could not save data \(error.localizedDescription)")
        }
        
        
    }

    func title_loadData(tag:Int){
        
        let selected_checklist = checklists.filter({$0.isselected == true}).count
        let personRequest:NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            let person = try managedObjextContext.fetch(personRequest)
            person[index_of_checklist].checklist = "\(selected_checklist)/\(self.checklists.count)"
            
            self.lbl_checklist_count.text = "(\(person[index_of_checklist].checklist ?? ""))"
            //print(person.first?.images?.count)
            
            do {
                try self.managedObjextContext.save()
                
                
            }catch {
                print("Could not save data \(error.localizedDescription)")
            }
            
        }catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
        
        
    }
}
