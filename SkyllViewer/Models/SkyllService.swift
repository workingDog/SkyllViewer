//
//  SkyllService.swift
//  SkyllViewer
//
//  Created by Ringo Wathelet on 2026/05/06.
//
import Foundation
import SwiftSkyllKit


@MainActor
final class SkyllService {
    static let shared = SkyllService()

    private let client: SkyllClient

    private init(client: SkyllClient = SkyllClient()) {
        self.client = client
    }

    func searchSkills(query: String, limit: Int = 10) async throws -> [SkyllSkill] {
        do {
            return try await client.searchSkills(
                query: query,
                limit: limit,
                includeContent: true,
                includeReferences: false
            )
        } catch let error as SkyllError {
            switch error {
                case let .serverError(_, response): print("Skyll API error: \(response.message)")
                default: print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    func fetchSkillFromRaw(for skill: SkillEntity) async throws -> String {
        if let rawString = skill.raw {
            do {
                let skillmd = try await client.fetchSkillFromRaw(for: rawString)
                return skillmd
            } catch {
                print(error.localizedDescription)
            }
        }
        return ""
    }
    
    func fetchSkillFromGithub(for skill: SkillEntity) async throws -> String {
        if let githubString = skill.github {
            do {
                let skillmd = try await client.fetchSkillFromGithub(for: githubString)
                return skillmd
            } catch {
                print(error.localizedDescription)
            }
        }
        return ""
    }

}
