//
//  FavoriteBook+CoreDataProperties.swift
//  BookSearcherApp
//
//  Created by Yoon on 7/31/25.
//
//

import Foundation
import CoreData


extension FavoriteBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteBook> {
        return NSFetchRequest<FavoriteBook>(entityName: "FavoriteBook")
    }

    @NSManaged public var isbn: String
    @NSManaged public var title: String
    @NSManaged public var author: String
    @NSManaged public var translator: String?
    @NSManaged public var thumbnail: String
    @NSManaged public var price: String
    @NSManaged public var contents: String

}

extension FavoriteBook : Identifiable {

}
