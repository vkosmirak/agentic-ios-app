//
//  TimerRowView.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import SwiftUI

/// Row view for displaying a single timer
struct TimerRowView: View {
    let timer: TimerModel
    let onToggle: () -> Void
    let onReset: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(timer.formattedRemainingTime)
                    .font(.system(size: 64, weight: .thin))
                    .foregroundColor(timer.isRunning ? .primary : .secondary)
                
                if let label = timer.label, !label.isEmpty {
                    Text(label)
                        .font(.system(size: 17))
                        .foregroundColor(.secondary)
                } else {
                    Text(timer.formattedDuration)
                        .font(.system(size: 17))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                if timer.isRunning || timer.remainingTime != timer.duration {
                    Button {
                        onReset()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(.plain)
                }
                
                Button {
                    onToggle()
                } label: {
                    Image(systemName: timer.isRunning ? "pause.fill" : "play.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    VStack(spacing: 16) {
        TimerRowView(
            timer: TimerModel(
                duration: 300,
                label: "Coffee Timer",
                isRunning: true,
                remainingTime: 245
            ),
            onToggle: {},
            onReset: {}
        )
        
        TimerRowView(
            timer: TimerModel(
                duration: 600,
                label: nil,
                isRunning: false,
                remainingTime: 600
            ),
            onToggle: {},
            onReset: {}
        )
        
        TimerRowView(
            timer: TimerModel(
                duration: 180,
                label: "Tea",
                isRunning: false,
                remainingTime: 120
            ),
            onToggle: {},
            onReset: {}
        )
    }
    .padding()
}

