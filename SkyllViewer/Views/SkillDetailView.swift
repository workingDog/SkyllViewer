//
//  SkillDetailView.swift
//  SkyllViewer
//
//  Created by Ringo Wathelet on 2026/05/06.
//
import SwiftUI
import Foundation


struct SkillDetailView: View {
    let skill: SkillEntity
    
    let service = SkyllService.shared
    
    @State private var showRaw: Bool = false
    
    var body: some View {
        let mkString = skill.content.isEmpty ? "content is empty or not available" : skill.content
        VStack(alignment: .leading, spacing: 16) {
            ScrollView {
                if showRaw {
                    Text(mkString)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                } else {
                    MKView(title: skill.title, text: mkString)
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Picker("", selection: $showRaw) {
                    Text("Raw").tag(true)
                    Text("Markdown").tag(false)
                }.pickerStyle(.segmented)
            }
        }
        .onAppear {
//            print("---> skill.content: \(skill.content)")
//            print("---> skill.raw: \(skill.raw)")
//            print("---> skill.github: \(skill.github)")
//            print("---> skill.source: \(skill.source)")
//            print()
            
            // if the skill.content.isEmpty, try fetching it from github
            Task {
                if self.skill.content.isEmpty {
                    do {
                        let markdown = try await SkyllService.shared.fetchSkillFromGithub(for: self.skill)
                        self.skill.content = markdown
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}
