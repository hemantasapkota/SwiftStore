//
//  ViewController.swift
//  SwiftStoreExample
//
//  Created by Hemanta Sapkota on 12/05/2015.
//  Copyright (c) 2015 Hemanta Sapkota. All rights reserved.
//
import UIKit

class SimpleKeyValueViewController: UIViewController {
  
  private var scrollView = UIScrollView()
  private var contentView = SimpleKeyValueView()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Swift Store Demo"
    
    setupViews()
  }
  
  private func setupViews() {
    view.backgroundColor = .white
    
    // Add scrollView to the main view
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(scrollView)
    
    // Setup scrollView constraints
    NSLayoutConstraint.activate([
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
    
    // Add contentView to scrollView
    contentView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(contentView)
    
    // Setup contentView constraints
    NSLayoutConstraint.activate([
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
    ])
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

class SimpleKeyValueView : UIView {
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = UIColor.white
        
        var keys = ["Name", "Address", "Phone", "Email"]
        
        var lastRow: SimpleRowView? = nil
        var index = 1
        
        for key in keys {
            let row = SimpleRowView(rowNumber: index, key: key)
            
            if let value = DB.store[key], !value.isEmpty {
                row.valueText.text = value
            }
            
            row.onSave = { (key, value) in
                DB.store[key] = value
            }
            
            row.onDelete = { key in
                DB.store.delete(key: key)
            }
            
            addSubview(row)
            row.snp.makeConstraints { (make) -> Void in
                if lastRow == nil {
                    make.top.equalTo(10)
                } else {
                    make.top.greaterThanOrEqualTo(lastRow!.snp.bottom).offset(5)
                }
                
                make.left.equalTo(0)
                make.width.equalTo(self.snp.width)
                make.height.equalTo(110)
                
                if index == keys.count {
                    make.bottom.equalTo(self.snp.bottom).offset(-10)
                }
                
                lastRow = row
                index = index + 1
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
