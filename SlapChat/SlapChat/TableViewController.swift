//
//  TableViewController.swift
//  SlapChat
//
//  Created by Flatiron School on 7/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    let store = DataStore.sharedDataStore
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchRecipientData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        store.fetchRecipientData()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.recipients.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("recipientCell", forIndexPath: indexPath)
        
        let eachRecipient = store.recipients[indexPath.row]
        cell.textLabel?.text = eachRecipient.name
        
        return cell
    }
    
    // You can use this to pass the selected recipient to the next view controller, which will display associated messages...
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // Or you can use a segue to pass the selected recipient...
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? MessagesTableViewController {
                let selectedRow = tableView.indexPathForSelectedRow
                let selectedRecipient = store.recipients[selectedRow!.row]
                destinationVC.recipient = selectedRecipient
        }
    }
    
}