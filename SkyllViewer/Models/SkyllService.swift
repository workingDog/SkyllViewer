//
//  SkyllService.swift
//  SkyllViewer
//
//  Created by Ringo Wathelet on 2026/05/06.
//
import Foundation


enum SkyllError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
}

final class SkyllService {
    
    static let shared = SkyllService()
    private init() {}
    
    private let baseURL = "https://api.skyll.app"
    
    // MARK: - Search
    
    func searchSkills(query: String, limit: Int = 10) async throws -> [SkyllSkill] {
        guard var components = URLComponents(string: "\(baseURL)/search") else {
            throw SkyllError.invalidURL
        }
        
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        
        guard let url = components.url else {
            throw SkyllError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
  //      print("---> data:\n \(String(data: data, encoding: .utf8) as AnyObject) \n")
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw SkyllError.requestFailed
        }
        
        do {
            let decoded = try JSONDecoder().decode(SkyllSearchResponse.self, from: data)
            return decoded.skills
        } catch {
            throw SkyllError.decodingFailed
        }
    }
}
