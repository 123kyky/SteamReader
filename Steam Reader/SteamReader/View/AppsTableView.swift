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
    @IBOutlet var tableView: UITableView!
    
    var filteredApps: [App]!
    var apps: [App]! {
        didSet {
            filteredApps = apps
        }
    }
    
    var delegate: AppsTableViewDelegate?
    
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
            filteredApps = apps
        } else {
            filteredApps = apps.filter { (app) -> Bool in
                return app.name!.lowercaseString.containsString(searchText.lowercaseString)
            }
        }
        
        tableView.reloadData()
    }
    
    // MARK: - UITableView Delegate & DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredApps.count
    }
    
    let CellIdentifier = "AppCell"
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? AppHeaderCell
        if cell == nil {
            cell = AppHeaderCell(style: .Default, reuseIdentifier: CellIdentifier)
        }
        
        let app = filteredApps[indexPath.row]
        cell!.appView!.configure(app)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.appsTableAppSelected(self, app: filteredApps[indexPath.row])
    }
    
}
