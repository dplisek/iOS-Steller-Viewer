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
        setupPresenters()
        setupViewControllers()
    }
}

// MARK: - Private functions
private extension SwinjectStoryboard {
    private static let storyPresenterImpl = StoryPresenterImpl()
    
    class func setupPresenters() {
        defaultContainer.register(StoryPresenter.self) { _ in storyPresenterImpl }
    }

    class func setupViewControllers() {
        defaultContainer.storyboardInitCompleted(StoryNavigationViewController.self) { (resolver, controller) in
        }
        defaultContainer.storyboardInitCompleted(StoryCollectionViewController.self) { (resolver, controller) in
            controller.storyPresenter = resolver.resolve(StoryPresenter.self)
        }
        defaultContainer.storyboardInitCompleted(StoryPageViewController.self) { (resolver, controller) in
            controller.storyPresenter = resolver.resolve(StoryPresenter.self)
        }
        defaultContainer.storyboardInitCompleted(StoryViewController.self) { (resolver, controller) in
            controller.storyPresenter = resolver.resolve(StoryPresenter.self)
        }
    }
}
