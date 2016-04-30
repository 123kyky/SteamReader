//
//  NewsItemHeader.swift
//  SteamReader
//
//  Created by Kyle Roberts on 4/29/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import UIKit

class NewsItemHeaderView: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var previewLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        importView()
    }
    
    init() {
        super.init(frame: CGRectZero)
        
        importView()
    }
    
    func importView() {
        NSBundle.mainBundle().loadNibNamed("NewsItemHeaderView", owner: self, options: nil)
        addSubview(view)
        view.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    func configure(newsItem: NewsItem?) {
        titleLabel.text = newsItem?.title
        previewLabel.text = newsItem?.contents
        // TODO: Set image
    }
    
}

class NewsItemHeaderCell: UITableViewCell {
    var newsItemView: NewsItemHeaderView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        newsItemView = NewsItemHeaderView()
        contentView.addSubview(newsItemView!)
        newsItemView?.snp_makeConstraints(closure: { (make) in
            make.edges.equalTo(self)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
