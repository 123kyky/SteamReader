//
//  AppHeaderView.swift
//  SteamReader
//
//  Created by Kyle Roberts on 4/29/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import UIKit

class AppHeaderView: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        importView()
    }
    
    init() {
        super.init(frame: CGRectZero)
        
        importView()
    }
    
    func importView() {
        NSBundle.mainBundle().loadNibNamed("AppHeaderView", owner: self, options: nil)
        addSubview(view)
        view.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    func configure(app: App?) {
        nameLabel.text = app?.name
        // TODO: Set image
    }

}

class AppHeaderCell: UITableViewCell {
    var appView: AppHeaderView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        appView = AppHeaderView()
        contentView.addSubview(appView!)
        appView?.snp_makeConstraints(closure: { (make) in
            make.edges.equalTo(self)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
