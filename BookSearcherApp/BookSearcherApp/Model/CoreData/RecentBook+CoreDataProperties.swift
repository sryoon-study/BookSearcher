//
//  RecentBook+CoreDataProperties.swift
//  BookSearcherApp
//
//  Created by Yoon on 8/1/25.
//
//

import Foundation
import CoreData


extension RecentBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentBook> {
        return NSFetchRequest<RecentBook>(entityName: "RecentBook")
    }

    @NSManaged public var isbn: String
    @NSManaged public var thumbnail: String
    @NSManaged public var title: String
    @NSManaged public var updateDate: Date
    @NSManaged public var author: String
    @NSManaged public var contents: String
    @NSManaged public var price: String
    @NSManaged public var translator: String?

}

extension RecentBook : Identifiable {

}
