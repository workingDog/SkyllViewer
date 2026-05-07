//
//  SkillSearchView.swift
//  SkyllViewer
//
//  Created by Ringo Wathelet on 2026/05/06.
//
import SwiftUI
import SwiftData


struct SkillSearchView: View {
    @Environment(SkillRepository.self) var repo: SkillRepository
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \SkillEntity.relevanceScore, order: .reverse)
    private var skills: [SkillEntity]
    
    @State private var query = "swiftdata"
    
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Search skills...", text: $query)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Search") {
                        Task {
                            await repo.searchAndStore(query: query)
                        }
                    }.buttonStyle(.borderedProminent)
                }
                .padding()
                
                if repo.isLoading {
                    ProgressView()
                }
                
                if let error = repo.error {
                    Text("Error: \(error.localizedDescription)")
                        .foregroundColor(.red)
                }
                
                List(skills) { skill in
                    NavigationLink(skill.title) {
                        SkillDetailView(skill: skill)
                    }
                    .listRowBackground(Color.green.opacity(0.4))
                }
            }
            .navigationTitle("Skyll Skills")
        }
    }
}
