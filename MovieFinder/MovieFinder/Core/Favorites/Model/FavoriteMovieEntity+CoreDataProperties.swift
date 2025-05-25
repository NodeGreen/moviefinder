//
//  FavoriteMovieEntity+CoreDataProperties.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//
//

import Foundation
import CoreData


extension FavoriteMovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovieEntity> {
        return NSFetchRequest<FavoriteMovieEntity>(entityName: "FavoriteMovieEntity")
    }

    @NSManaged public var imdbID: String?
    @NSManaged public var title: String?
    @NSManaged public var year: String?
    @NSManaged public var poster: String?

}

extension FavoriteMovieEntity : Identifiable {

}
