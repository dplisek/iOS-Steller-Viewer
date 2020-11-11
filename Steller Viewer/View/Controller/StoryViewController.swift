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
    
    var storyPresenter: StoryPresenter!

    var index = 0
    
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
        guard let landscape = landscape else { return }
        activityIndicator.startAnimating()
        imageView.isHidden = true
        storyPresenter.image(for: index, landscape: landscape) { [weak self] (data) in
            guard landscape == self?.landscape else { return }
            self?.activityIndicator.stopAnimating()
            guard let data = data else { return }
            self?.imageView.image = UIImage(data: data)
            self?.imageView.isHidden = false
        }
    }
}
