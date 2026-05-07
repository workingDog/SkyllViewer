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
    
    @State private var query = ""
    
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Search skills...", text: $query)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.search)
                        .onSubmit {
                            startSearch()
                        }
                    
                    Button("Search") {
                        startSearch()
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
                
                List {
                    ForEach(skills) { skill in
                        NavigationLink(skill.title) {
                            SkillDetailView(skill: skill)
                        }
                        .padding(10)
                        .listRowBackground(Color.green.opacity(0.2))
                    }
                    .onDelete(perform: deleteSkills)
                }
            }
            .navigationTitle("Skyll Skills")
        }
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Button("Delete All", role: .destructive) {
                    deleteAllSkills()
                }.buttonStyle(.glassProminent)
            }
        }
    }
    
    private func startSearch() {
        Task {
            await repo.searchAndStore(query: query)
        }
    }
    
    private func deleteSkills(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(skills[index])
        }
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete skills: \(error)")
        }
    }

    private func deleteAllSkills() {
        for skill in skills {
            modelContext.delete(skill)
        }
        do {
            try modelContext.save()
        } catch {
            print("Failed to clear all skills: \(error)")
        }
    }
}
