//
//  Person+CoreDataProperties.swift
//  CoreDataTutor
//
//  Created by Anupkumar on 11/05/18.
//  Copyright © 2018 Anupkumar. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var title: String?
    @NSManaged public var descriptionactivity: String?
    
    @NSManaged public var time: String?
    @NSManaged public var date: String?
    
    //@NSManaged public var images: Data?
    
    @NSManaged public var index_img:Int16
    
    @NSManaged public var id:Int16
    
    @NSManaged public var checklist: String?
    
    @NSManaged public var istimerrunning: Bool

}
