//
//  Networking.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 17.04.2021.
//

import Foundation

protocol Session {
    func load<A>(_ resource: Resource<A>, completion: @escaping (A?) -> ())
}

struct Environment {
    let session: Session
    static var env = Environment()
    init(session: Session = URLSession.shared) {
        self.session = session
    }
}

extension URLSession: Session {}

extension URLSession {
    func load<A>(_ resource: Resource<A>, completion: @escaping (A?) -> ()) {
        print(resource.urlRequest.url?.absoluteString)
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

func makeSearchResource(for text: String, at page: Int, size perPage: Int = 20) -> Resource<[Word]> {
    return Resource<[Word]>(get: URL(
                                    string: "words/search",
                                    relativeTo: basicURL)!,
                            parameters: [URLQueryItem(name: "search", value: text), URLQueryItem(name: "page", value: "\(page)"), URLQueryItem(name: "pageSize", value: "\(perPage)")])
}