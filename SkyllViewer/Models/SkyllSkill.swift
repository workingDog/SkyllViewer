//
//  SkyllSkill.swift
//  SkyllViewer
//
//  Created by Ringo Wathelet on 2026/05/06.
//
import Foundation

// MARK: - API Response
struct SkyllSearchResponse: Codable {
    let query: String
    let count: Int
    let skills: [SkyllSkill]
}

// MARK: - SkyllSkill
struct SkyllSkill: Identifiable, Codable {
    let id, title, description: String
    let version, allowedTools: String?
    let source: String
    let refs: Refs
    let installCount: Int
    let relevanceScore: Double
    let content: String
    let rawContent: String?
    let metadata: SkillMetadata
    let references: [String]
    let fetchError: String?

    enum CodingKeys: String, CodingKey {
        case id, title, description, version
        case allowedTools = "allowed_tools"
        case source, refs
        case installCount = "install_count"
        case relevanceScore = "relevance_score"
        case content
        case rawContent = "raw_content"
        case metadata, references
        case fetchError = "fetch_error"
    }
}

// MARK: - SkillMetadata
struct SkillMetadata: Codable {
    let license: String?
    let metadata: MetadataMetadata?
}

// MARK: - MetadataMetadata
struct MetadataMetadata: Codable {
    let author, version: String
}

// MARK: - Refs
struct Refs: Identifiable, Codable {
    let id = UUID()
    let skillsSh, github: String
    let raw: String

    enum CodingKeys: String, CodingKey {
        case skillsSh = "skills_sh"
        case github, raw
    }
}

