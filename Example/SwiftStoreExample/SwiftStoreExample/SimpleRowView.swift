//
//  RowView.swift
//  SwiftStoreExample
//
//  Created by Hemanta Sapkota on 31/05/2015.
//  Copyright (c) 2015 Hemanta Sapkota. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

/* Simple Row View */
class SimpleRowView : UIView {
    
    /* Label */
    var label: UILabel!
    
    /* Key Text */
    var keyText: UITextField!
    
    /* Value Text */
    var valueText: UITextField!
    
    /* Save Button */
    var saveBtn: UIButton!
    
    /* Delete */
    var deleteBtn: UIButton!
    
    /* Handler */
    var onSave: ( (String, String) -> Void)?
    
    /* Handler */
    var onDelete: ( (String) -> Void)?
    
    init(rowNumber: Int, key: String) {
        super.init(frame: UIScreen.mainScreen().bounds)
        
        label = UILabel()
        label.text = "\(rowNumber)"
        label.textColor = UIColor(rgba: "#2c3e50")
        addSubview(label)
        label.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(5)
            make.left.equalTo(5)
        }
        
        keyText = UITextField()
        keyText.layer.borderWidth = 0.5
        keyText.layer.borderColor = UIColor(rgba: "#bdc3c7").CGColor
        keyText.placeholder = "Key"
        keyText.text = "\(key)"
        keyText.enabled = false
        addSubview(keyText)
        keyText.snp_makeConstraints { (make) -> Void in
            make.top.greaterThanOrEqualTo(5)
            make.left.equalTo(label.snp_right).offset(10)
            make.width.equalTo(self.snp_width).offset(-60)
            make.height.equalTo(30)
        }
        
        valueText = UITextField()
        valueText.placeholder = "Value"
        valueText.layer.borderWidth = 0.5
        valueText.layer.borderColor = UIColor(rgba: "#bdc3c7").CGColor
        addSubview(valueText)
        valueText.snp_makeConstraints { (make) -> Void in
            make.top.greaterThanOrEqualTo(keyText.snp_bottom).offset(5)
            make.left.equalTo(label.snp_right).offset(10)
            make.width.equalTo(self.snp_width).offset(-60)
            make.height.equalTo(30)
        }
        
        saveBtn = UIButton(type: UIButtonType.System)
        saveBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        saveBtn.setTitle("Save", forState: UIControlState.Normal)
        saveBtn.backgroundColor = UIColor(rgba: "#27ae60")
        addSubview(saveBtn)
        saveBtn.snp_makeConstraints { (make) -> Void in
            make.top.greaterThanOrEqualTo(valueText.snp_bottom).offset(5)
            make.left.equalTo(valueText.snp_left)
            make.width.equalTo(self.snp_width).dividedBy(3)
        }
        
        deleteBtn = UIButton(type: UIButtonType.System)
        deleteBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        deleteBtn.setTitle("Delete", forState: UIControlState.Normal)
        deleteBtn.backgroundColor = UIColor(rgba: "#e74c3c")
        addSubview(deleteBtn)
        deleteBtn.snp_makeConstraints { (make) -> Void in
            make.top.greaterThanOrEqualTo(valueText.snp_bottom).offset(5)
            make.right.equalTo(valueText.snp_right)
            make.width.equalTo(self.snp_width).dividedBy(3)
        }
        
        let sep = UILabel()
        sep.backgroundColor = UIColor(rgba: "#bdc3c7")
        addSubview(sep)
        sep.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(0.5)
            make.bottom.equalTo(self.snp_bottom)
            make.width.equalTo(self.snp_width)
        }
        
        saveBtn.addTarget(self, action: "handleSave", forControlEvents: UIControlEvents.TouchUpInside)
        deleteBtn.addTarget(self, action: "handleDelete", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func handleSave() {
        if let executeSave = onSave {
            let key = keyText.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            let value = valueText.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            executeSave(key, value)
        }
    }
    
    func handleDelete() {
        valueText.text = ""
        if let executeDelete = onDelete {
            let key = keyText.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            executeDelete(key)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    