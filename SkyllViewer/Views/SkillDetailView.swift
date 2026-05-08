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
    
    @State private var showRaw: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ScrollView {
                if showRaw {
                    Text(skill.content)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                } else {
                    MKView(title: skill.title, text: skill.content)
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
    }
}
