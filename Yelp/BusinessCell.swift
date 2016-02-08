//
//  BusinessCell.swift
//  Yelp
//
//  Created by Karlygash Zhuginissova on 2/4/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var categoriesLabel: UILabel!
    
    @IBOutlet weak var reviewsLabel: UILabel!
    
    var business: Business! {
        didSet {
            nameLabel.text = business.name
            if business.imageURL != nil {
                thumbImageView.setImageWithURL(business.imageURL!)
            }
            categoriesLabel.text = business.categories
            addressLabel.text = business.address
            reviewsLabel.text = "\(String(business.reviewCount!)) Reviews"
            distanceLabel.text = business.distance
            ratingImageView.setImageWithURL(business.ratingImageURL!)
            
        }
    }
    
    //            let coordinate = dictionary["coordinate"] as? NSDictionary
    //            var longtitude = 0.0
    //            var latitude = 0.0
    //            if coordinate != nil {
    //                let longtitudePoint = coordinate!["longtitude"] as? Double
    //                let latitudePoint = coordinate!["latitude"] as? Double
    //                longtitude = longtitudePoint!
    //                latitude = latitudePoint!
    //            }
    //            self.longtitude = longtitude
    //            self.latitude = latitude

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layoutMargins = UIEdgeInsetsZero
        self.preservesSuperviewLayoutMargins = false
        
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
