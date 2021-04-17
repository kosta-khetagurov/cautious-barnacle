//
//  Networking.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 17.04.2021.
//

import Foundation

extension URLSession {
    func load<A>(_ resource: Resource<A>, completion: @escaping (A?) -> ()) {
        dataTask(with: resource.urlRequest) { (data, response, error) in
            if let error = error {
                print(error)
            }
            completion(data.flatMap(resource.parse))
        }.resume()
    }
}

struct Resource<A> where A:Decodable {
    var urlRequest: URLRequest
    let parse: (Data) -> A?
}

extension Resource where A: Decodable {
    init(get url: URL, parameters: [URLQueryItem]?) {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = parameters

        self.urlRequest = URLRequest(url: urlComponents.url!)
        
        self.parse = { data in
            do {
                return try JSONDecoder().decode(A.self, from: data)
                
            } catch {
                print(error)
            }
            return nil
        }
    }
}

let basicURL = URL(string: "https://dictionary.skyeng.ru/api/public/v1/")!
let searchRequest = URLRequest(
                        url: URL(
                            string: "words/search",
                            relativeTo: basicURL)!,
                        cachePolicy: .reloadRevalidatingCacheData,
                        timeoutInterval: 60
                    )

let meaningRequest = URLRequest(
    url: URL(
        string: "meanings",
        relativeTo: basicURL)!,
    cachePolicy: .reloadRevalidatingCacheData,
    timeoutInterval: 60
)

let searchResource = Resource<[Word]>(get: URL(
                                        string: "words/search",
                                        relativeTo: basicURL)!, parameters: [URLQueryItem(name: "search", value: "hello"), URLQueryItem(name: "page", value: "1"), URLQueryItem(name: "pageSize", value: "2")])


