//
//  AddNewActivitiesViewController.swift
//  PepperSquareTask
//
//  Created by Anupkumar on 20/04/19.
//  Copyright © 2019 Anupkumar. All rights reserved.
//

import UIKit
import CoreData



class AddNewActivitiesViewController: BaseClassViewController,UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate {
    
    
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var txt_title: UITextField!
    
    @IBOutlet weak var lbl_description: UILabel!
   
    @IBOutlet weak var txt_view: UITextView!
    
    
    @IBOutlet weak var viewdue_date: UIView!
    
    
    @IBOutlet weak var lbl_due_date: UILabel!
    
    
    @IBOutlet weak var txt_due_date: UITextField!
    
    
    @IBOutlet weak var collection_view: UICollectionView!
    
    @IBOutlet weak var bottom_Constraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottom_Constraint_scroll_view_and_top_view: NSLayoutConstraint!
    
    @IBOutlet weak var bottom_Constraint_safe_area_and_top_view: NSLayoutConstraint!
    
    @IBOutlet weak var view_submit: UIView!
    
    @IBOutlet weak var lbl_submit: UILabel!
    
    @IBOutlet weak var view_img: UIView!
    
    @IBOutlet weak var logo_image_view: UIView!
    
    @IBOutlet weak var scroll_view: UIScrollView!
    
    @IBOutlet weak var lbl_logo_name: UILabel!
    
    @IBOutlet weak var big_logo_image: UIImageView!
    
    var arr_image = [UIImage]()
    
    var placeholder_txt = "Enter Description"
    
    var lastContentOffset: CGFloat = 0
    
    var add_new_activity = true
    
    var presents = [[ArrayImages]]()
    
    var singlepresents = [ArrayImages]()
    
    var managedObjextContext:NSManagedObjectContext!
    
     var person = [Person]()
    
    var delegate : to_pass_arr_images?
    
    var index_to_update = 0
    
    var logo_img = UIImage()
    
     var reloadcoredatatable = {() -> () in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        scroll_view.delegate = self
        
        managedObjextContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        to_design_txtfield()

        // Do any additional setup after loading the view.
        
       
        viewdue_date.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.btn_date_clicked)))
        view_img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.btn_photosaction)))
        
        view_submit.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.view_submit_clicked)))
        
        
    }
    
    func loadData(){
        let presentRequest:NSFetchRequest<ArrayImages> = ArrayImages.fetchRequest()
        
        do {
            singlepresents = try managedObjextContext.fetch(presentRequest)
            print(singlepresents.count)
            print(".......")
           
            self.collection_view.reloadData()
        }catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
        
        
    }
    
    @objc func view_submit_clicked(){
        if self.txt_title.text?.isEmpty == true{
            to_add_image(str:"Please enter title")
        }else if self.txt_view.text?.isEmpty == true || self.txt_view.text == placeholder_txt{
            to_add_image(str:"Please enter description")
        }else if self.txt_due_date.text?.isEmpty == true{
            to_add_image(str:"Please select date")
        }else if singlepresents.count == 0{
            to_add_image(str:"Please Add Images")
            
            
        }else{
        
        
        let presentRequest:NSFetchRequest<ArrayImages> = ArrayImages.fetchRequest()
        
        do {
            singlepresents = try managedObjextContext.fetch(presentRequest)
            print(singlepresents.count)
            print(".......")
            
            
        }catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
        
        
        
        self.delegate?.to_pass_arr_imges(presents: [singlepresents],index_img:presents.count)
        
       
        if add_new_activity == true{
            let person = Person(context: managedObjextContext)
        
            person.title = self.txt_title.text
            person.descriptionactivity = self.txt_view.text
            person.date = self.txt_due_date.text
            person.time = "00.00.00"
            person.istimerrunning = false
        
            person.index_img = Int16(presents.count - 1)
            person.checklist = "0/0"
            person.id = Int16(self.person.count)
            
            to_save_data_and_perform_pop()
            
        }else{
            let personRequest:NSFetchRequest<Person> = Person.fetchRequest()
            
            do {
                 let person = try managedObjextContext.fetch(personRequest)
                person[index_to_update].title = self.txt_title.text
                person[index_to_update].descriptionactivity = self.txt_view.text
                person[index_to_update].date = self.txt_due_date.text
               
                to_save_data_and_perform_pop()
               
            }catch {
                print("Could not load data from database \(error.localizedDescription)")
            }
            
        }
        }
       
    }
    
    func to_save_data_and_perform_pop(){
        do {
            try self.managedObjextContext.save()
            reloadcoredatatable()
            self.navigationController?.popViewController(animated: true)
            
        }catch {
            print("Could not save data \(error.localizedDescription)")
        }
        
    }
    
    func title_loadData(){
        let personRequest:NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            person = try managedObjextContext.fetch(personRequest)
            //self.collection_view.reloadData()
            print("........134")
            print(person)
            //print(person.first?.images?.count)
            
        }catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
        
        
    }
    
    func to_add_image(str:String){
        let alert = UIAlertController.init(title: "", message: str, preferredStyle: .alert)
        
       
        let action_no = UIAlertAction.init(title: "Ok", style: .default , handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
            
            
        })
        
        
        
        alert.addAction(action_no)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc func btn_date_clicked(){
        
        self.view.endEditing(true)
        
        to_add_date_picker()
        
        showAnimate(view_set: custom_date_picker)
        
        reloadpicker = { [weak self] ()  in
            ///UI chnages in main tread
            DispatchQueue.main.async {
               
                self?.btn_doneclicked()
            }
        }
        
        
    }
    
    @objc func btn_doneclicked(){
       
        self.txt_due_date.text = picked_date
        
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == scroll_view && add_new_activity == false{
        
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            // move up
            showImage(false)
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y) {
            // move down
            showImage(true)
        }
        }
        
    }
    func showImage(_ show: Bool) {
        if add_new_activity == false{
        UIView.animate(withDuration: 0.2) {
            if show == false{
                self.update_new_activity()
                
                
            }else{
                self.adding_new_activity()
            }
            self.logo_image_view.alpha = show ? 0.0 : 1.0
            
        }
        }
    }
    func to_design_txtfield(){
        self.txt_title.delegate = self
        self.txt_view.delegate = self
        self.txt_due_date.isUserInteractionEnabled = false
        self.txt_title.returnKeyType = .next
        txt_view.textColor = UIColor.lightGray
        to_create_tool_bar()
        if add_new_activity == true{
            adding_new_activity()
            self.navigationItem.title = "Add Activity"
            self.lbl_submit.text = "Submit"
            
            title_loadData()
            
        }else{
            if let navController = navigationController {
                System.clearNavigationBar(forBar: navController.navigationBar)
                navController.view.backgroundColor = .clear
            }
            
            update_new_activity()
            self.lbl_submit.text = "Update"
            update_loadData()
            loadData()
        }
        
    }
    
    func update_loadData(){
        let personRequest:NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            person = try managedObjextContext.fetch(personRequest)
            
             self.txt_title.text =  person[index_to_update].title
            
            self.txt_view.text = person[index_to_update].descriptionactivity
            
            self.txt_due_date.text = person[index_to_update].date
            
            self.lbl_logo_name.text = person[index_to_update].title
            
            self.big_logo_image.image = logo_img
            //self.collection_view.reloadData()
            print("........134")
            print(person)
            //print(person.first?.images?.count)
            
            
        }catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
        
        
    }
    
    func update_new_activity(){
        self.bottom_Constraint_scroll_view_and_top_view.priority = UILayoutPriority(rawValue: 999)
        self.bottom_Constraint_safe_area_and_top_view.priority = UILayoutPriority(rawValue: 100)
    }
    
    func adding_new_activity(){
        self.bottom_Constraint_scroll_view_and_top_view.priority = UILayoutPriority(rawValue: 100)
        self.bottom_Constraint_safe_area_and_top_view.priority = UILayoutPriority(rawValue: 999)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.txt_title:
            self.txt_view.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        print(".......textViewDidBeginEditing")
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = placeholder_txt
            textView.textColor = UIColor.lightGray
            
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            
        }
        
        
        to_adjust_hieght(textView:textView)
        
        
    }
    
    func to_adjust_hieght(textView:UITextView){
        let size = CGSize(width: self.txt_view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                
                constraint.constant = estimatedSize.height + 10
                
            }
        }
        
    }
    
    func to_create_tool_bar(){
        let tollbar = UIToolbar()
        tollbar.sizeToFit()
        
        let donebutton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneaction))
        tollbar.setItems([donebutton], animated: true)
        
        self.txt_view.inputAccessoryView = tollbar
        
    }
    @objc func doneaction() {
        
        self.txt_view.resignFirstResponder()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            bottom_Constraint?.constant = isKeyboardShowing ? (keyboardFrame!.height + 5) : 12
            
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                
                self.view.layoutIfNeeded()
                
            }, completion: { (completed) in
                
                if isKeyboardShowing {
                    print("keyboard_showing")
                   
                    self.showImage(true)
                }else{
                   // self.showImage(false)
                }
                
            })
        }
    }
    
}

extension AddNewActivitiesViewController:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    @objc func image_picker(){
        self.view.endEditing(true)
        btn_photosaction(self)
    }
    
    
    @objc func btn_photosaction(_ sender: Any)
    {
        
        var AC = UIAlertController()
        if UIDevice.current.userInterfaceIdiom == .pad{
            AC = UIAlertController(title: "Upload Image", message: "", preferredStyle: .alert)
        }else{
            AC = UIAlertController(title: "Upload Image", message: "", preferredStyle: .actionSheet)
        }
        
        
        let clickBtn = UIAlertAction(title: "Take Picture", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        })
        let cameraRollBtn = UIAlertAction(title: "Upload Picture From Camera Roll", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            let picker = UIImagePickerController()
            
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
            
            
            
        })
        let noBtn = UIAlertAction(title: "Cancel", style: .default, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(clickBtn)
        AC.addAction(cameraRollBtn)
        AC.addAction(noBtn)
        
        self.parent!.present(AC, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            
            picker.dismiss(animated: true, completion: nil);
            if add_new_activity == true{
            self.arr_image.append(image)
            
            let item = (self.arr_image.count) - 1
            let insertionIndexPath = NSIndexPath.init(item: item, section: 0)
            
            self.collection_view.insertItems(at: [insertionIndexPath as IndexPath])
            }else{
 
            createPresentItem (with :image)
            }
        }
    }
    
    
    func createPresentItem (with image:UIImage) {
        
        let presentItem = ArrayImages(context: managedObjextContext)
        presentItem.image =  image.jpegData(compressionQuality: CGFloat(0.3))!
        
                do {
                    try self.managedObjextContext.save()
                    self.loadData()
                }catch {
                    print("Could not save data \(error.localizedDescription)")
                }

        
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil);
    }
    
}

extension AddNewActivitiesViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if add_new_activity == true{
        return self.arr_image.count
        }else{
            return singlepresents.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddNewActivityCollectionViewCell", for: indexPath) as? AddNewActivityCollectionViewCell
        if add_new_activity == false{
    
        let presentItem = singlepresents[indexPath.row]
        
        if let presentImage = UIImage(data: presentItem.image as! Data) {
            cell?.img_view.image = presentImage
        }
 
        }else{
            
        cell?.img_view.image = arr_image[indexPath.item]
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            return CGSize.init(width: (collectionView.frame.width / 2 - 10), height: collectionView.frame.width / 2.2 )
        
    }
}
