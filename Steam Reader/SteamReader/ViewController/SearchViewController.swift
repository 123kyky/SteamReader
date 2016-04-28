//
//  SearchViewController.swift
//  Steam Reader
//
//  Created by Kyle Roberts on 4/26/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, AppsTableViewDelegate, SearchViewDelegate {
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var appsTableView: AppsTableView!
    @IBOutlet weak var searchViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        appsTableView.apps = App.MR_findAll() as? [App] ?? []
        appsTableView.delegate = self
        searchView.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    }

    // MARK: - AppsTableView & SearchView Delegate
    
    let AppTableSegueIdentifier = "ShowAppTable"
    func appsTableAppSelected(appsTable: AppsTableView, app: App) {
        performSegueWithIdentifier(AppTableSegueIdentifier, sender: app)
    }
    
    func searchViewExpanded(searchView: SearchView) {
        
    }
    
    func searchViewCollapsed(searchView: SearchView) {
    
    }
    
    func searchViewTextUpdated(searchView: SearchView, searchText: String) {
        appsTableView.filter(searchText)
    }
    
    func searchViewSearched(searchView: SearchView, searchText: String) {
        appsTableView.filter(searchText)
    }
    
    // MARK: - Layouts
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == AppTableSegueIdentifier {
            if let destinationViewController = segue.destinationViewController as? AppViewController {
                destinationViewController.app = sender as! App
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let keyboardFrame: CGRect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        self.searchViewBottomConstraint.constant = keyboardFrame.size.height
        UIView.animateWithDuration(notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.searchViewBottomConstraint.constant = 0
        UIView.animateWithDuration(notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        self.view.endEditing(true)
    }
    
}
