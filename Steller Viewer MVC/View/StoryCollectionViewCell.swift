//
//  StoryCollectionViewCell.swift
//  Steller Viewer MVC
//
//  Created by plech on 02/11/2020.
//

import UIKit

class StoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var storyId: String?
}
