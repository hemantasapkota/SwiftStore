//
//  ExampleViewController.swift
//  SwiftStoreExample
//
//  Created by Hemanta Sapkota on 31/05/2015.
//  Copyright (c) 2015 Hemanta Sapkota. All rights reserved.
//

import Foundation
import UIKit

class ExampleViewController : UIViewController {
    
    override func viewDidLoad() {
        title = "Swift Store Demo"
        
        let exampleView = ExampleView()
        
        exampleView.viewPusher = { viewController in
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        view = exampleView
    }
}

class ExampleView : UIView, UITableViewDataSource, UITableViewDelegate {
    
    /* Items */
    var items = ["Saving Key / Value Pairs" ]
    
    /* Table View */
    var tableView: UITableView!
    
    var viewPusher: ( (UIViewController) -> Void)!
    
    init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        addSubview(tableView)
        tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(self.snp_width)
            make.height.equalTo(self.snp_height)
        }
        
        tableView.registerClass(ExampleViewCell.self, forCellReuseIdentifier: "ExampleViewCell")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ExampleViewCell") as! ExampleViewCell
        
        cell.textLabel?.text = items[indexPath.item]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let item = indexPath.item
        
        if item == 0 {
            viewPusher(SimpleKeyValueViewController())
        } else if item == 1 {
//            viewPusher(SimpleCollectionViewController())
        }
    }
}

class ExampleViewCell : UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}