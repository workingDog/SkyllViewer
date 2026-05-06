//
//  Item.swift
//  SkyllViewer
//
//  Created by Ringo Wathelet on 2026/05/06.
//
import Foundation
import SwiftData


@Model
final class SkillEntity {
    @Attribute(.unique) var id: String
    
    var title: String
    var skillDescription: String?
    var content: String
    var source: String?
    
    var relevanceScore: Double?
    var installCount: Int?
    
    var fetchedAt: Date
    
    init(from api: SkyllSkill) {
        self.id = api.id
        self.title = api.title
        self.skillDescription = api.description
        self.content = api.content
        self.source = api.source
        self.relevanceScore = api.relevanceScore
        self.installCount = api.installCount
        self.fetchedAt = Date()
    }
}
