//
//  SkillRepository.swift
//  SkyllViewer
//
//  Created by Ringo Wathelet on 2026/05/06.
//
import Foundation
import SwiftData
import SwiftSkyllKit


@Observable
@MainActor
final class SkillRepository {
    
    private let service = SkyllService.shared
    private let context: ModelContext
    
    var isLoading: Bool = false
    var error: Error?
    
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - Search + Persist
    
    func searchAndStore(query: String) async {
        isLoading = true
        error = nil
        do {
            let results = try await service.searchSkills(query: query)
            for skill in results {
                upsert(skill)
            }
            try context.save()
        } catch {
            self.error = error
        }
        isLoading = false
    }
    
    // MARK: - Upsert
    
    private func upsert(_ skill: SkyllSkill) {
        let descriptor = FetchDescriptor<SkillEntity>(
            predicate: #Predicate { $0.id == skill.id }
        )
        if let existing = try? context.fetch(descriptor).first {
            // Update existing entity
            existing.title = skill.title
            existing.skillDescription = skill.description
            existing.content = skill.content ?? ""
            existing.source = skill.source
            existing.relevanceScore = skill.relevanceScore
            existing.installCount = skill.installCount
            existing.fetchedAt = Date()
        } else {
            // Insert new entity
            let new = SkillEntity(from: skill)
            context.insert(new)
        }
    }
}
