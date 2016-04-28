//
//  SearchView.swift
//  Steam Reader
//
//  Created by Kyle Roberts on 4/26/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import UIKit
import SnapKit

protocol SearchViewDelegate {
    func searchViewTextUpdated(searchView: SearchView, searchText: String)
    func searchViewSearched(searchView: SearchView, searchText: String)
    func searchViewExpanded(searchView: SearchView)
    func searchViewCollapsed(searchView: SearchView)
}

class SearchView: UIView, UITextFieldDelegate {
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var expandButton: UIButton!
    
    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var collapseButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchField: UITextField!
    
    var collapsed = false
    
    var delegate: SearchViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSBundle.mainBundle().loadNibNamed("SearchView", owner: self, options: nil)
        self.addSubview(self.view)
        view.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        collapseButtonTapped(collapseButton)
    }
    
    @IBAction func expandButtonTapped(sender: AnyObject) {
        collapsed = false
        UIView.animateWithDuration(0.3) {
            self.expandButton.alpha = 0
            self.searchContainer.alpha = 1
        }
        
        delegate?.searchViewExpanded(self)
        searchField.becomeFirstResponder()
    }
    
    @IBAction func collapseButtonTapped(sender: AnyObject) {
        collapsed = true
        UIView.animateWithDuration(0.3) {
            self.expandButton.alpha = 1
            self.searchContainer.alpha = 0
        }
        
        delegate?.searchViewCollapsed(self)
        delegate?.searchViewSearched(self, searchText: "")
        searchField.resignFirstResponder()
    }
    
    @IBAction func searchTextChanged(sender: AnyObject) {
        //delegate?.searchViewTextUpdated(self, searchText: searchField.text!)
    }
    
    @IBAction func searchButtonTapped(sender: AnyObject) {
        delegate?.searchViewSearched(self, searchText: searchField.text!)
    }
}
