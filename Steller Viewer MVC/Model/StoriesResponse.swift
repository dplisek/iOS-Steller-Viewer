//
//  StoriesResponse.swift
//  Steller MVC
//
//  Created by plech on 01/11/2020.
//

import Foundation

struct User: Decodable {
    let display_name: String?
    let avatar_image_url: String?
}

struct Likes: Decodable {
    let count: Int?
}

struct Story: Decodable {
    let id: String?
    let cover_src: String?
    let landscape_share_image: String?
    let user: User?
    let likes: Likes?
}

struct StoriesResponse: Decodable {
    let data: [Story]?
}
