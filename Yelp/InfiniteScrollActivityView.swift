//
//  InfiniteScrollActivityView.swift
//  Yelp
//
//  Created by Karlygash Zhuginissova on 2/7/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class InfiniteScrollActivityView: UIActivityIndicatorView {

    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    static let defaultHeight:CGFloat = 60.0
    
    required init?(aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupActivityIndicator()
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        setupActivityIndicator()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
    }
    
    func setupActivityIndicator() {
        activityIndicatorView.activityIndicatorViewStyle = .Gray
        activityIndicatorView.hidesWhenStopped = true
        self.addSubview(activityIndicatorView)
    }
    
    override func stopAnimating() {
        self.activityIndicatorView.stopAnimating()
        self.hidden = true
    }
    
    override func startAnimating() {
        self.hidden = false
        self.activityIndicatorView.startAnimating()
    }

}
