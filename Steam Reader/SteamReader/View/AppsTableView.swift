//
//  AppsTableView.swift
//  Steam Reader
//
//  Created by Kyle Roberts on 4/26/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import UIKit

protocol AppsTableViewDelegate {
    func appsTableAppSelected(appsTable: AppsTableView, app: App)
}

class AppsTableView: UIView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private var tableView: UITableView!
    
    var delegate: AppsTableViewDelegate?
    
    var sections: [Section]! {
        didSet {
            if !filtering {
                tableView.reloadData()
            }
        }
    }
    private var filteredContents: [App]!
    var searchContents: [App]! {
        didSet {
            filteredContents = searchContents
            if filtering {
                tableView.reloadData()
            }
        }
    }
    
    var filtering: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSBundle.mainBundle().loadNibNamed("AppsTableView", owner: self, options: nil)
        addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        tableView.registerClass(AppHeaderCell.self, forCellReuseIdentifier: CellIdentifier)
    }
    
    func filter(searchText: String) {
        if searchText == "" {
            filteredContents = searchContents
        } else {
            filteredContents = searchContents.filter { (app) -> Bool in
                return app.name!.lowercaseString.containsString(searchText.lowercaseString)
            }
        }
        
        tableView.reloadData()
    }
    
    // MARK: - UITableView Delegate & DataSource
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filtering ? nil : sections[section].title
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filtering ? 1 : sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtering ? filteredContents.count : sections[section].apps.count
    }
    
    let CellIdentifier = "AppCell"
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? AppHeaderCell
        if cell == nil {
            cell = AppHeaderCell(style: .Default, reuseIdentifier: CellIdentifier)
        }
        
        let app = filtering ? filteredContents[indexPath.row] : sections[indexPath.section].apps[indexPath.row]
        cell!.appView!.configureWithApp(app)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.appsTableAppSelected(self, app: filteredContents[indexPath.row])
    }
    
}

class Section: NSObject {
    var title: String
    var apps: [App]
    
    init(title: String, apps: [App]) {
        self.title = title
        self.apps = apps
    }
}
