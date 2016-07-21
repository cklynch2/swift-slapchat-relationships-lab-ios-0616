//
//  DataStore.swift
//  SlapChat
//
//  Created by Flatiron School on 7/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import CoreData

class DataStore {
    
    var messages:[Message] = []
    var recipients: [Recipient] = []
    
    static let sharedDataStore = DataStore()
    
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    // MARK : - Fetch request functions
    
    // Now that the data model includes multiple entities, you can generalize the fetch function to take the entity name as a parameter. This allows you to call the fetch function from either Recipient or Messages view controller, depending on which data you need to get.
    func fetchDataByEntity(entityName: String, key: String?) -> [AnyObject] {
        var fetchArray = [AnyObject]()
        var error: NSError? = nil
        let request = NSFetchRequest(entityName: entityName)
        
        if let sortKey = key {
            let sortByKey = NSSortDescriptor(key: sortKey, ascending: true)
            request.sortDescriptors = [sortByKey]
        }
        
        do {
            // You do not need to cast in this case, because you are already working with the most general AnyObject type.
            fetchArray = try managedObjectContext.executeFetchRequest(request) 
        } catch let nserror as NSError {
            error = nserror
            print("Fetch request caused an error: \(error)")
        }
        return fetchArray
    }
    
    // Or, you can have different fetch functions for each entity:
    func fetchMessageData () {
        var error: NSError? = nil
        
        let messagesRequest = NSFetchRequest(entityName: "Message")
        
        let messageCreatedAtSorter = NSSortDescriptor(key: "createdAt", ascending: true)
        messagesRequest.sortDescriptors = [messageCreatedAtSorter]
        
        do {
            messages = try managedObjectContext.executeFetchRequest(messagesRequest) as! [Message]
        } catch let nserror as NSError {
            error = nserror
            messages = []
            print("Message fetch request caused an error: \(error)")
        }
        
        if messages.count == 0 {
            generateTestData()
        }
    }
    
    func fetchRecipientData () {
        var error: NSError? = nil
        
        let recipientsRequest = NSFetchRequest(entityName: "Recipient")
        
        let recipientNameSorter = NSSortDescriptor(key: "name", ascending: true)
        recipientsRequest.sortDescriptors = [recipientNameSorter]
        
        do {
            recipients = try managedObjectContext.executeFetchRequest(recipientsRequest) as! [Recipient]
        } catch let nserror as NSError{
            error = nserror
            recipients = []
            print("Recipient fetch request caused an error: \(error)")
        }
        
        if recipients.count == 0 {
            generateTestData()
        }
    }
    
    // MARK: - Generate test data
    
    func generateTestData() {
        
        let messageOne: Message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: managedObjectContext) as! Message
        messageOne.content = "What up diggity dog?"
        messageOne.createdAt = NSDate()
        
        // Create a recipient:
        let recipientOne = NSEntityDescription.insertNewObjectForEntityForName("Recipient", inManagedObjectContext: managedObjectContext) as! Recipient
        recipientOne.name = "Claire"
        recipientOne.email = "cklynch2@gmail.com"
        recipientOne.phoneNumber = "608-354-4824"
        
        // Create the relationship between recipient and message:
        messageOne.recipient = recipientOne
        
        let messageTwo: Message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: managedObjectContext) as! Message
        messageTwo.content = "It's so hot in here, I'm dreaming of ice cream!"
        messageTwo.createdAt = NSDate()
        
        // Add the second message to the same recipient as before, as an example of the relationship, one recipient to many messages:
        recipientOne.messages?.insert(messageTwo)
    
        // Create a second test recipient and with a test message.
        let recipientTwo = NSEntityDescription.insertNewObjectForEntityForName("Recipient", inManagedObjectContext: managedObjectContext) as! Recipient
        recipientTwo.name = "Cenker"
        
        let messageThree: Message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: managedObjectContext) as! Message
        messageThree.content = "You are a Turkish BOSS!"
        messageThree.createdAt = NSDate()
        
        messageThree.recipient = recipientTwo
        
        let recipientThree = NSEntityDescription.insertNewObjectForEntityForName("Recipient", inManagedObjectContext: managedObjectContext) as! Recipient
        recipientThree.name = "Ken"
        
        let messageFour: Message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: managedObjectContext) as! Message
        messageFour.content = "I know you're sensible, stop being so sensible."
        messageFour.createdAt = NSDate()
        
        messageFour.recipient = recipientThree
        
        let messageFive: Message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: managedObjectContext) as! Message
        messageFive.content = "BIG BIRD!!!"
        messageFive.createdAt = NSDate()
        
        messageFive.recipient = recipientThree
        
        saveContext()
        fetchMessageData()
        fetchRecipientData()
    }
    
    // MARK: - Core Data stack
    // Managed Object Context property getter. This is where we've dropped our "boilerplate" code.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("SlapChat", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SlapChat.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    //MARK: Application's Documents directory
    // Returns the URL to the application's Documents directory.
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.FlatironSchool.SlapChat" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
}