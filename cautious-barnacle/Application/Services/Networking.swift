//
//  Networking.swift
//  cautious-barnacle
//
//  Created by Konstantin Khetagurov on 17.04.2021.
//

import Foundation

protocol Session {
    func load<A>(_ resource: Resource<A>, completion: @escaping (Result<A,Error>) -> ())
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
    func load<A>(_ resource: Resource<A>, completion: @escaping (Result<A,Error>) -> ()) {
        dataTask(with: resource.urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            if let data = data.flatMap(resource.parse) {
                completion(.success(data))
            }
        }.resume()
    }
}

struct Resource<A> {
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

extension Resource {
    func map<B>(_ transform: @escaping (A) -> B) -> Resource<B> {
        return Resource<B>(urlRequest: urlRequest) { self.parse($0).map(transform) }
    }
}

struct ResourceAndResponse {
    let resource: Resource<Any>
    let response: Any?
    
    init<A>(resource: Resource<A>, response: A?) {
        self.resource = resource.map { $0 }
        self.response = response.map { $0 }
    }
}

class TestSession: Session {
    var responses: [ResourceAndResponse]
    
    init(responses: [ResourceAndResponse]) {
        self.responses = responses
    }
    
    func load<A>(_ resource: Resource<A>, completion: @escaping (Result<A, Error>) -> ()) {
        guard let idx = responses.firstIndex(where: { $0.resource.urlRequest == resource.urlRequest }), let response = responses[idx].response as? A else {
            fatalError("No such resource: \(resource.urlRequest.url?.absoluteString)")
        }
        responses.remove(at: idx)
        completion(.success(response))
    }
    
    func verify() -> Bool {
        return responses.isEmpty
    }
}

let basicURL = URL(string: "https://dictionary.skyeng.ru/api/public/v1/")!

func makeSearchResource(for text: String, at page: Int, size perPage: Int = 20) -> Resource<[Word]> {
    return Resource<[Word]>(get: URL(
                                string: "words/search",
                                relativeTo: basicURL)!,
                            parameters: [URLQueryItem(name: "search", value: text), URLQueryItem(name: "page", value: "\(page)"), URLQueryItem(name: "pageSize", value: "\(perPage)")])
}

func makeMeaningResource(for ids: String, updateAt: String? = nil) -> Resource<[Meaning]> {
    return Resource<[Meaning]>(get: URL(
                                string: "meanings",
                                relativeTo: basicURL)!,
                            parameters: [URLQueryItem(name: "ids", value: ids)])
}
