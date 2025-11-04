//
//  AlarmRowView.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import SwiftUI

/// Row view for displaying a single alarm
struct AlarmRowView: View {
    let alarm: AlarmModel
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(alarm.formattedTime)
                    .font(.system(size: 64, weight: .thin))
                    .foregroundColor(alarm.isEnabled ? .primary : .secondary)
                
                if let label = alarm.label, !label.isEmpty {
                    Text(label)
                        .font(.system(size: 17))
                        .foregroundColor(.secondary)
                }
                
                Text(alarm.formattedRepeatDays)
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: Binding(
                get: { alarm.isEnabled },
                set: { _ in onToggle() }
            ))
            .labelsHidden()
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    VStack(spacing: 16) {
        AlarmRowView(
            alarm: AlarmModel(
                time: Date(),
                label: "Wake Up",
                isEnabled: true,
                repeatDays: [.monday, .wednesday, .friday]
            ),
            onToggle: {}
        )
        
        AlarmRowView(
            alarm: AlarmModel(
                time: Date(),
                label: nil,
                isEnabled: false,
                repeatDays: []
            ),
            onToggle: {}
        )
    }
    .padding()
}

