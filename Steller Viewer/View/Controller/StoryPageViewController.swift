//
//  StoryPageViewController.swift
//  Steller Viewer MVC
//
//  Created by plech on 04/11/2020.
//

import UIKit

class StoryPageViewController: UIPageViewController {
    var storyPresenter: StoryPresenter!

    var position = 0
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers(
            [instantiateViewController(position: position) ?? UIViewController()],
            direction: .forward,
            animated: false
        )
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
              position < storyPresenter.storyCount else { return nil }
        storyVC.index = position
        return storyVC
    }
}
