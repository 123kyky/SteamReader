//
//  FavoritesTableView.swift
//  SteamReader
//
//  Created by Kyle Roberts on 8/29/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import UIKit

protocol FavoritesTableViewDelegate {
    func favoritesTableAppSelected(favoritesTable: FavoritesTableView, app: App)
}

class FavoritesTableView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private var tableView: UITableView!
    
    var delegate: FavoritesTableViewDelegate?
    
    var sections: [Section]!
    
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
    
    // MARK: - UITableView Delegate & DataSource
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].apps.count
    }
    
    let CellIdentifier = "AppCell"
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? AppHeaderCell
        if cell == nil {
            cell = AppHeaderCell(style: .Default, reuseIdentifier: CellIdentifier)
        }
        
        cell!.selectionStyle = .None
        
        let app = sections[indexPath.section].apps[indexPath.row]
        cell!.appView!.configureWithApp(app)
        cell!.appView!.imageView.image = nil
        if app.details == nil {
            NetworkManager.singleton.fetchDetailsForApps([app])
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = sections[indexPath.section].apps[indexPath.row]
        delegate?.favoritesTableAppSelected(self, app: app)
    }
}
