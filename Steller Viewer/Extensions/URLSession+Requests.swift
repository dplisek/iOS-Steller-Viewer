//
//  URLSession+Requests.swift
//  Steller Viewer MVC
//
//  Created by plech on 02/11/2020.
//

import Foundation
import RxSwift
import RxCocoa

extension URLSession {
    struct Endpoints {
        static let stories = URL(string: "https://api.steller.co/v1/users/76794126980351029/stories")!
    }

    func get<T: Decodable>(_ type: T.Type, url: URL) -> Observable<T> {
        rx.response(request: URLRequest(url: url))
            .map { (response, data) in
                guard 200..<300 ~= response.statusCode else {
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                }
                return try JSONDecoder().decode(T.self, from: data)
            }
    }

    func getAsData(url: URL) -> Observable<Data> {
        rx.response(request: URLRequest(url: url))
            .map { (response, data) in
                guard 200..<300 ~= response.statusCode else {
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                }
                return data
            }
    }
}
