//
//  FavoriteBook+CoreDataProperties.swift
//  BookSearcherApp
//
//  Created by Yoon on 7/31/25.
//
//

import CoreData
import Foundation

public extension FavoriteBook {
    @nonobjc class func fetchRequest() -> NSFetchRequest<FavoriteBook> {
        return NSFetchRequest<FavoriteBook>(entityName: "FavoriteBook")
    }

    @NSManaged var isbn: String
    @NSManaged var title: String
    @NSManaged var author: String
    @NSManaged var translator: String?
    @NSManaged var thumbnail: String
    @NSManaged var price: String
    @NSManaged var contents: String
}

extension FavoriteBook: Identifiable {}
