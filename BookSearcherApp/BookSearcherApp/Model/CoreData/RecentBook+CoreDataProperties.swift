//
//  RecentBook+CoreDataProperties.swift
//  BookSearcherApp
//
//  Created by Yoon on 8/1/25.
//
//

import CoreData
import Foundation

public extension RecentBook {
    @nonobjc class func fetchRequest() -> NSFetchRequest<RecentBook> {
        return NSFetchRequest<RecentBook>(entityName: "RecentBook")
    }

    @NSManaged var isbn: String
    @NSManaged var thumbnail: String
    @NSManaged var title: String
    @NSManaged var updateDate: Date
    @NSManaged var author: String
    @NSManaged var contents: String
    @NSManaged var price: String
    @NSManaged var translator: String?
}

extension RecentBook: Identifiable {}
