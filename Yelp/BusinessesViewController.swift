//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var button: UIButton = UIButton(type: UIButtonType.Custom)
    var leftBarButton: UIBarButtonItem!
    
    var loadingMoreView:InfiniteScrollActivityView?
    
    var isMoreDataLoading = false
    
    var customSearchBar = UISearchBar(frame: CGRectMake(0, 0, 200, 20))
    
    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    var searchedCategories: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorInset = UIEdgeInsetsZero
        
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        
        customSearchBar.tintColor = UIColor.whiteColor()
        navigationItem.titleView = customSearchBar
        customSearchBar.delegate = self
        
        //image for button
        button.setImage(UIImage(named: "map.png"), forState: UIControlState.Normal)
        //function for button
        button.addTarget(self, action: "performSegue", forControlEvents: UIControlEvents.TouchUpInside)
        //frame
        button.frame = CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem(customView: button)
        leftBarButton = barButton
        //leftbarbuttonitem is custom button(barbutton)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        navigationItem.title = "Yelp"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: 20.0)!]
        
        Business.searchWithTerm("Restaurant", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredBusinesses = self.businesses
            self.tableView.reloadData()
            for business in businesses {
                print(business.name!)
                print(business.address!)
                print(business.longitude!)
                print(business.latitude!)
            }
        })
        
        tableView.reloadData()
        

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredBusinesses = searchText.isEmpty ? businesses : businesses!.filter({(business: Business) -> Bool in
            return business.name!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            
            })
        tableView.reloadData()
        
        }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.navigationItem.leftBarButtonItem = nil
        customSearchBar.showsCancelButton = true
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = self.tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height
            
            if (scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.dragging) {
                isMoreDataLoading = true
                
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        let myRequest = NSURLRequest()
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(myRequest, completionHandler: {(data, response, error) in
            self.isMoreDataLoading = false
            
            Business.searchWithTerm("Restaurant", completion: { (businesses: [Business]!, error: NSError!) -> Void in
                  self.tableView.reloadData()
            })
 
             self.loadingMoreView!.stopAnimating()
            
        });
        task.resume()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBusinesses?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = filteredBusinesses[indexPath.row]
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func performSegue(){
        performSegueWithIdentifier("mapSegue", sender: nil)
    }
    
    // MARK: - Navigation

 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destinationVC = segue.destinationViewController as! MapViewController
        destinationVC.businesses = filteredBusinesses
        
    }
}
