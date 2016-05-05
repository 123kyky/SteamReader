//
//  AppHeaderView.swift
//  SteamReader
//
//  Created by Kyle Roberts on 4/29/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import UIKit
import AlamofireImage
import Async

class AppHeaderView: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var app: App?
    
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
    
    func configureWithApp(app: App?) {
        self.app = app
        nameLabel.text = app?.name
        
        app!.addObserver(self, forKeyPath: "details", options: NSKeyValueObservingOptions.New, context: nil)
        if app!.details != nil {
            configureWithDetails(app!.details!)
        }
    }
    
    func configureWithDetails(details: AppDetails) {
        imageView.af_setImageWithURL(NSURL(string: details.headerImage!)!, placeholderImage: nil, filter: nil, imageTransition: .CrossDissolve(0.3), completion: { response in
            self.imageView.image = response.result.value
        })
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "details" && app!.details != nil {
            Async.main {
                self.configureWithDetails(self.app!.details!)
            }
        }
    }
    
    deinit {
        app?.removeObserver(self, forKeyPath: "details")
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
