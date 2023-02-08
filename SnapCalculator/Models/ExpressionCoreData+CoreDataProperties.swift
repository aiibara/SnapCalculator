//
//  ExpressionCoreData+CoreDataProperties.swift
//  SnapCalculator
//
//  Created by Widya Limarto on 08/02/23.
//
//

import Foundation
import CoreData


extension ExpressionCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpressionCoreData> {
        return NSFetchRequest<ExpressionCoreData>(entityName: "ExpressionCoreData")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var detail: String?
    @NSManaged public var createdDate: Date?
    @NSManaged public var result: String?
    @NSManaged public var storage: String?

}

extension ExpressionCoreData : Identifiable {

}
