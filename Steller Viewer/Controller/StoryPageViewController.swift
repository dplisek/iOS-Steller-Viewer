//
//  StoryPageViewController.swift
//  Steller Viewer MVC
//
//  Created by plech on 04/11/2020.
//

import UIKit

class StoryPageViewController: UIPageViewController {
    var stories = [Story]()
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
        guard
            let currentVC = viewController as? StoryViewController,
            let position = stories.firstIndex(where: { $0.id == currentVC.story?.id }) else { return nil }
        return instantiateViewController(position: position - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard
            let currentVC = viewController as? StoryViewController,
            let position = stories.firstIndex(where: { $0.id == currentVC.story?.id }) else { return nil }
        return instantiateViewController(position: position + 1)
    }
}

// MARK: - Private functions
private extension StoryPageViewController {
    func instantiateViewController(position: Int) -> StoryViewController? {
        guard let storyVC = storyboard?.instantiateViewController(withIdentifier: "StoryViewController") as? StoryViewController,
              position >= 0,
              position < stories.count else { return nil }
        storyVC.story = stories[position]
        return storyVC
    }
}
