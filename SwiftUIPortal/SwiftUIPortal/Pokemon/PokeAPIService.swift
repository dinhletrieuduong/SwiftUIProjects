//
//  PokeAPIService.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 16/01/2023.
//

import SwiftUI

let Colors: [String: Color] = [
    "Bug": Color(hex: 0xFFA6B91A),
    "Dark": Color(hex: 0xFF705746),
    "Dragon": Color(hex: 0xFF6F35FC),
    "Electric": Color(hex: 0xFFF7D02C),
    "Fairy": Color(hex: 0xFFD685AD),
    "Fighting": Color(hex: 0xFFC22E28),
    "Fire": Color(hex: 0xFFEE8130),
    "Flying": Color(hex: 0xFFA98FF3),
    "Ghost": Color(hex: 0xFF735797),
    "Grass": Color(hex: 0xFF7AC74C),
    "Ground": Color(hex: 0xFFE2BF65),
    "Ice": Color(hex: 0xFF96D9D6),
    "Normal": Color(hex: 0xFFA8A77A),
    "Poison": Color(hex: 0xFFA33EA1),
    "Psychic": Color(hex: 0xFFF95587),
    "Rock": Color(hex: 0xFFB6A136),
    "Steel": Color(hex: 0xFFB7B7CE),
    "Water": Color(hex: 0xFF6390F0),
]
class PokeAPIService {
    public static let shared = PokeAPIService()
    
    private init() {}
    private let urlSession = URLSession.shared
    private let baseURL = URL(string: "https://pokeapi.co/api/v2")!
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecorder = JSONDecoder()
        return jsonDecorder
    }()
    
    // Endpoints for API
    enum Endpoint: String, CaseIterable {
        case pokemon
    }
    
    public enum PokeApiServiceError: Error {
        case apiError
        case invalidEndpoint
        case invalidResponse
        case noData
        case decodeError
    }
    
    func fetchPokemons(from endpoint: Endpoint) async throws -> Pokemons {
        let url = baseURL.appendingPathComponent(endpoint.rawValue)
        let (data, _) = try await urlSession.data(from: url)
        let response = try jsonDecoder.decode(Pokemons.self, from: data)
        return response
    }
    
    func fetchPokemonInfo(from url: String) async throws -> Pokemon {
        let pokemonURL = URL(string: url)!
        let (data, _) = try await urlSession.data(from: pokemonURL)
        let response = try jsonDecoder.decode(Pokemon.self, from: data)
        return response
    }
    
    func fetchPokemonImage(from url: String) async throws -> Image {
        let imageURL = URL(string: url)!
        let (data, _) = try await urlSession.data(from: imageURL)
        let image = UIImage(data: data)!
        return Image(uiImage: image)
    }
    
    private func fetchResources<T: Decodable>(url: URL, completion: @escaping (Result<T, PokeApiServiceError>) -> Void) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        let queryItems = [URLQueryItem(name: "limit", value: "100")]
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        urlSession.dataTask(with: url){ (result) in
            switch result {
            case .success(let (response, data)):
                // print("success")
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                do {
                    let values = try self.jsonDecoder.decode(T.self, from: data)
                    completion(.success(values))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure(let error):
                print(error)
                completion(.failure(.apiError))
            }
        }.resume()
    }
    
    public func fetchPokes(from endpoint: Endpoint, result: @escaping (Result<Pokemons, PokeApiServiceError>) -> Void) {
        let url = baseURL
            .appendingPathComponent(endpoint.rawValue)
        fetchResources(url: url, completion: result)
    }
}

extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask { return dataTask(with: url) { (data, response, error) in
        
        if let error = error {
            result(.failure(error))
            return
        }
        
        guard let response = response, let data = data else {
            let error = NSError(domain: "error", code: 0, userInfo: nil)
            result(.failure(error))
            return
        }
        
        result(.success((response, data)))
    }
    }
}
