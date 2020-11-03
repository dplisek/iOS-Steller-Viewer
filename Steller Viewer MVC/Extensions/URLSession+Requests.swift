//
//  URLSession+Requests.swift
//  Steller Viewer MVC
//
//  Created by plech on 02/11/2020.
//

import Foundation

extension URLSession {
    struct Endpoints {
        static let stories = URL(string: "https://api.steller.co/v1/users/76794126980351029/stories")!
    }
    
    func get<T: Decodable>(_ type: T.Type, url: URL, completion: @escaping (T?, Error?) -> Void) {
        dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let response = response as? HTTPURLResponse,
                      200..<400 ~= response.statusCode,
                      let data = data,
                      let result = try? JSONDecoder().decode(T.self, from: data) else {
                    completion(nil, error)
                    return
                }
                completion(result, nil)
            }
        }.resume()
    }
    
    func getAsData(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let response = response as? HTTPURLResponse,
                      200..<400 ~= response.statusCode,
                      let data = data else {
                    completion(nil, error)
                    return
                }
                completion(data, nil)
            }
        }.resume()
    }
}
