//
//  StoryViewController.swift
//  Steller Viewer MVC
//
//  Created by plech on 04/11/2020.
//

import UIKit
import RxSwift

class StoryViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var storiesViewModel: StoriesViewModel!

    var index = 0
    
    private var disposeBag = DisposeBag()
    
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
        disposeBag = DisposeBag()
        storiesViewModel.stories
            .map { [weak self] stories in stories[self?.index ?? 0] }
            .flatMap { [weak self] story in (self?.landscape ?? false) ? story.landscapeImage : story.image }
            .asDriver(onErrorJustReturn: nil)
            .drive(imageView.rx.image)
            .disposed(by: disposeBag)
    }
}
