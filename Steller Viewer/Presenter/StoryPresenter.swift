//
//  StoryPresenter.swift
//  Steller Viewer
//
//  Created by plech on 07/11/2020.
//

import Foundation
import SwinjectStoryboard

struct StoryInfo {
    let username: String?
    let likes: Int?
}

protocol StoryPresenter {
    var storyCount: Int { get }
    func fetchStories(completion: @escaping (Bool, Error?) -> Void)
    func story(at index: Int) -> StoryInfo
    func image(for index: Int, landscape: Bool, completion: @escaping (Data?) -> Void)
}

class StoryPresenterImpl: StoryPresenter {
    private var stories = [Story]()
    
    var storyCount: Int {
        stories.count
    }
    
    func fetchStories(completion: @escaping (Bool, Error?) -> Void) {
        URLSession.shared.get(StoriesResponse.self, url: URLSession.Endpoints.stories) { [weak self] (response, error) in
            guard let stories = response?.data else {
                completion(false, error)
                return
            }
            self?.stories = stories
            completion(true, nil)
        }
    }
    
    func story(at index: Int) -> StoryInfo {
        StoryInfo(
            username: stories[index].user?.display_name,
            likes: stories[index].likes?.count
        )
    }
    
    func image(for index: Int, landscape: Bool, completion: @escaping (Data?) -> Void) {
        guard let src = landscape ? stories[index].landscape_share_image : stories[index].cover_src,
              let url = URL(string: src) else {
            completion(nil)
            return
        }
        URLSession.shared.getAsData(url: url) { (data, error) in
            completion(data)
        }
    }
}
