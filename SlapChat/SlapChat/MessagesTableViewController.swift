//
//  MessagesTableViewController.swift
//  SlapChat
//
//  Created by Flatiron School on 7/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreData

class MessagesTableViewController: UITableViewController {
    
    var recipient: Recipient!
    var messagesArray: [Message] = []
    let store = DataStore.sharedDataStore
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let messagesSet = recipient.messages {
            return messagesSet.count
        }
        print("This recipient has no messages.")
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath)
        
        // You have to convert the messages Set associated with the recipient into an array, so you can access the elements by row.
        for message in recipient.messages! {
            messagesArray.append(message)
        }
        cell.textLabel?.text = messagesArray[indexPath.row].content
        
        return cell
    }
}

