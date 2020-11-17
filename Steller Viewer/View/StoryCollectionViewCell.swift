//
//  StoryCollectionViewCell.swift
//  Steller Viewer MVC
//
//  Created by plech on 02/11/2020.
//

import UIKit
import RxSwift

class StoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.font = .styleUser
            nameLabel.textColor = .styleBlue
        }
    }
    @IBOutlet weak var likesLabel: UILabel! {
        didSet {
            likesLabel.font = .styleUser
            likesLabel.textColor = .styleDarkBlue
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var index: Int?
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
