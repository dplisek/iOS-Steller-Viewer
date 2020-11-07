//
//  StoryViewController.swift
//  Steller Viewer MVC
//
//  Created by plech on 04/11/2020.
//

import UIKit

class StoryViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var story: Story?
    
    private var landscape: Bool? {
        didSet {
            guard oldValue != landscape else { return }
            updateImage()
        }
    }

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        landscape = view.frame.width > view.frame.height
    }
}

// MARK: - Private functions
private extension StoryViewController {
    func updateImage() {
        guard let landscape = landscape,
              let urlString = landscape ? story?.landscape_share_image : story?.cover_src,
              let url = URL(string: urlString) else { return }
        activityIndicator.startAnimating()
        imageView.isHidden = true
        URLSession.shared.getAsData(url: url) { [weak self] (data, error) in
            guard landscape == self?.landscape else { return }
            self?.activityIndicator.stopAnimating()
            guard let data = data else { return }
            self?.imageView.image = UIImage(data: data)
            self?.imageView.isHidden = false
        }
    }
}
