//
//  StoriesViewModel.swift
//  Steller Viewer
//
//  Created by plech on 07/11/2020.
//

import Foundation
import SwinjectStoryboard
import RxCocoa
import RxSwift
import UIKit

protocol StoryViewModel {
    var username: Observable<String?> { get }
    var likes: Observable<Int?> { get }
    var image: Observable<UIImage?> { get }
    var landscapeImage: Observable<UIImage?> { get }
}

protocol StoriesViewModel {
    var stories: Observable<[StoryViewModel]> { get }
    func refresh()
}

class StoryViewModelImpl: StoryViewModel {
    var username: Observable<String?> {
        Observable.just(story.user?.display_name)
    }
    var likes: Observable<Int?> {
        Observable.just(story.likes?.count)
    }
    var image: Observable<UIImage?> {
        fetchImage()
        return imageRelay.asObservable()
    }
    var landscapeImage: Observable<UIImage?> {
        fetchLandscapeImage()
        return landscapeImageRelay.asObservable()
    }
    
    private let story: Story
    private let imageRelay = BehaviorRelay<UIImage?>(value: nil)
    private var imageLoaded = false
    private let landscapeImageRelay = BehaviorRelay<UIImage?>(value: nil)
    private var landscapeImageLoaded = false
    private let disposeBag = DisposeBag()

    init(story: Story) {
        self.story = story
    }
    
    private func fetchImage() {
        guard !imageLoaded,
              let url = story.cover_src.flatMap({ URL(string: $0) }) else { return }
        imageLoaded = true
        URLSession.shared.getAsData(url: url)
            .map { UIImage(data: $0) }
            .bind(to: imageRelay)
            .disposed(by: disposeBag)
    }
    
    private func fetchLandscapeImage() {
        guard !landscapeImageLoaded,
              let url = story.landscape_share_image.flatMap({ URL(string: $0) }) else { return }
        landscapeImageLoaded = true
        URLSession.shared.getAsData(url: url)
            .map { UIImage(data: $0) }
            .bind(to: landscapeImageRelay)
            .disposed(by: disposeBag)
    }
}

class StoriesViewModelImpl: StoriesViewModel {
    var stories: Observable<[StoryViewModel]> {
        storiesRelay.asObservable()
    }
    
    private let storiesRelay = BehaviorRelay(value: [StoryViewModel]())
    private let disposeBag = DisposeBag()
    
    func refresh() {
        URLSession.shared.get(StoriesResponse.self, url: URLSession.Endpoints.stories)
            .map { $0.data ?? [Story]() }
            .map { stories in
                stories.map { StoryViewModelImpl(story: $0) }
            }
            .bind(to: storiesRelay)
            .disposed(by: disposeBag)
    }
}
