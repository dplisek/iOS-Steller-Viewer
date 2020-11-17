//
//  StoryPageViewController.swift
//  Steller Viewer MVC
//
//  Created by plech on 04/11/2020.
//

import UIKit
import RxSwift

class StoryPageViewController: UIPageViewController {
    var storiesViewModel: StoriesViewModel!

    var position = 0

    private let disposeBag = DisposeBag()
    private var totalCount = 0
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        storiesViewModel.stories
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] stories in
                guard let self = self else { return }
                self.totalCount = stories.count
                guard self.viewControllers?.isEmpty ?? true else { return }
                self.setViewControllers(
                    [self.instantiateViewController(position: self.position) ?? UIViewController()],
                    direction: .forward,
                    animated: false
                )
            })
            .disposed(by: disposeBag)
        dataSource = self
    }
}

// MARK: - UIPageViewControllerDataSource
extension StoryPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? StoryViewController else { return nil }
        return instantiateViewController(position: currentVC.index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? StoryViewController else { return nil }
        return instantiateViewController(position: currentVC.index + 1)
    }
}

// MARK: - Private functions
private extension StoryPageViewController {
    func instantiateViewController(position: Int) -> StoryViewController? {
        guard let storyVC = storyboard?.instantiateViewController(withIdentifier: "StoryViewController") as? StoryViewController,
              position >= 0,
              position < totalCount else { return nil }
        storyVC.index = position
        return storyVC
    }
}
