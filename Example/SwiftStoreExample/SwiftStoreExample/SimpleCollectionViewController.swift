//
//  SimpleCollectionViewController.swift
//  SwiftStoreExample
//
//  Created by Hemanta Sapkota on 3/06/2015.
//  Copyright (c) 2015 Hemanta Sapkota. All rights reserved.
//

import Foundation
import UIKit

class SimpleCollectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var sectionTitles = ["Common Names", "Popular Places"]
    
    override func viewDidLoad() {
        
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view = tableView
    }
    
}

extension SimpleCollectionViewController {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! TableViewCell
        cell.textLabel!.text = "Hello"
        return cell
    }
    
}

extension SimpleCollectionViewController {
    
    class TableViewCell : UITableViewCell {
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}