//
//  Recipient+CoreDataProperties.swift
//  SlapChat
//
//  Created by Flatiron School on 7/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Recipient {

    @NSManaged var name: String?
    @NSManaged var email: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var twitterHandle: String?
    @NSManaged var messages: Set<Message>?

}
