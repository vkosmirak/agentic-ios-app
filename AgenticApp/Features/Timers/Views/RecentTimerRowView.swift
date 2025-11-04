//
//  RecentTimerRowView.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import SwiftUI

/// Row view for displaying a recent timer
struct RecentTimerRowView: View {
    let timer: TimerModel
    let onStart: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(timer.formattedDuration)
                    .font(.system(size: 48, weight: .thin, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(timer.formattedDurationComponents)
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button {
                onStart()
            } label: {
                Image(systemName: "play.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(
                        Circle()
                            .fill(Color.green)
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        
        Divider()
            .padding(.leading, 16)
    }
}

#Preview {
    VStack(spacing: 0) {
        RecentTimerRowView(
            timer: TimerModel(duration: 900, label: nil),
            onStart: {}
        )
        
        RecentTimerRowView(
            timer: TimerModel(duration: 1538, label: nil),
            onStart: {}
        )
    }
    .background(Color(.systemGroupedBackground))
}

