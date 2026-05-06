//
//  SkyllViewerApp.swift
//  SkyllViewer
//
//  Created by Ringo Wathelet on 2026/05/06.
//
import SwiftUI
import SwiftData


@main
struct SkyllViewerApp: App {
    @State private var skillRepo: SkillRepository
    let sharedModelContainer: ModelContainer
    
    init() {
        let schema = Schema([SkillEntity.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            sharedModelContainer = try ModelContainer(for: schema, configurations: [config])
            let context = ModelContext(sharedModelContainer)
            _skillRepo = State(initialValue: SkillRepository(context: context))
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            SkillSearchView()
                .environment(skillRepo)
                .modelContainer(sharedModelContainer)
                .onAppear {
                    let appSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).last?.relativePath ?? "no path"
                    print("---> \(appSupportDir)")
                }
        }
    }
    
}
