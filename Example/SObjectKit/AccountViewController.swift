//
//  AccountViewController.swift
//  qtilities
//
//  Created by QUINTON WALL on 11/28/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftlySalesforce
import FCAlertView
import PromiseKit
import SObjectKit
import SwiftyJSON

class AccountViewController: UITableViewController {
    
     var allAccounts: [Account] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl?.addTarget(self, action: #selector(AccountViewController.handleRefresh), forControlEvents: UIControlEvents.ValueChanged)
        //register the qtilities default account cell
        //let bundle = NSBundle(forClass: self.dynamicType)
       // tableView.registerNib(UINib(nibName: "AccountTableCellView", bundle: NSBundle(forClass: AccountTableCellView.self)), forCellReuseIdentifier: "accountcell")

        loadData()

        
    }
    
    func loadData() {
        
        
        firstly {
             SalesforceAPI.Query(soql: Account.soqlGetAllStandardFields).request()
            
        }.then {
            ( result) -> () in
            
                let j = JSON(result["records"] as! NSArray)
            
                for (_, subJson) in j {
                    self.allAccounts.append(Account(json: subJson))
                }
        }.always {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            
        }.error { _ in
                let fcdialog = FCAlertView()
                fcdialog.showAlertInView(self, withTitle: "Kaboom!", withSubtitle: "Something gone bust.", withCustomImage: UIImage(named: "close-x"), withDoneButtonTitle: "OK", andButtons: nil)
                fcdialog.colorScheme = fcdialog.flatGreen
                fcdialog.dismissOnOutsideTouch = true
        }
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        loadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("accountcell", forIndexPath: indexPath) as! UITableViewCell
        //cell.bind(allAccounts[indexPath.item])
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.allAccounts.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}