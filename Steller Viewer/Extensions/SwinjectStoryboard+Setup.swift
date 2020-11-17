//
//  SwinjectStoryboard+Setup.swift
//  Steller Viewer
//
//  Created by plech on 09/11/2020.
//

import Foundation
import SwinjectStoryboard

extension SwinjectStoryboard {
    public static func setup() {
        setupViewModels()
        setupViewControllers()
    }
}

// MARK: - Private functions
private extension SwinjectStoryboard {
    private static let storiesViewModelImpl = StoriesViewModelImpl()

    class func setupViewModels() {
        defaultContainer.register(StoriesViewModel.self) { _ in storiesViewModelImpl }
    }

    class func setupViewControllers() {
        defaultContainer.storyboardInitCompleted(StoryNavigationViewController.self) { (_, _) in
        }
        defaultContainer.storyboardInitCompleted(StoryCollectionViewController.self) { (resolver, controller) in
            controller.storiesViewModel = resolver.resolve(StoriesViewModel.self)
        }
        defaultContainer.storyboardInitCompleted(StoryPageViewController.self) { (resolver, controller) in
            controller.storiesViewModel = resolver.resolve(StoriesViewModel.self)
        }
        defaultContainer.storyboardInitCompleted(StoryViewController.self) { (resolver, controller) in
            controller.storiesViewModel = resolver.resolve(StoriesViewModel.self)
        }
    }
}
