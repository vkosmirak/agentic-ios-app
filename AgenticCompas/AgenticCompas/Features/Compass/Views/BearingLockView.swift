//
//  BearingLockView.swift
//  AgenticCompas
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import SwiftUI

/// View for bearing lock functionality
struct BearingLockView: View {
    let isLocked: Bool
    let isDeviating: Bool
    let deviation: Double?
    let onToggle: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            // Lock button
            Button(action: onToggle) {
                Image(systemName: isLocked ? "lock.fill" : "lock.open")
                    .font(.system(size: 24))
                    .foregroundColor(isLocked ? .red : .primary)
                    .frame(width: 60, height: 60)
                    .background(
                        Circle()
                            .fill(Color(.systemGray6))
                    )
            }
            .accessibilityLabel(isLocked ? "Unlock bearing" : "Lock bearing")
            .accessibilityHint(isLocked ? "Tap to unlock the current bearing" : "Tap to lock the current bearing")
            
            // Deviation indicator
            if isLocked, let deviation = deviation {
                Text(String(format: "%.1f°", deviation))
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(isDeviating ? .red : .secondary)
                    .accessibilityLabel("Deviation: \(String(format: "%.1f degrees", deviation))")
            }
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        BearingLockView(
            isLocked: false,
            isDeviating: false,
            deviation: nil,
            onToggle: {}
        )
        
        BearingLockView(
            isLocked: true,
            isDeviating: false,
            deviation: 2.5,
            onToggle: {}
        )
        
        BearingLockView(
            isLocked: true,
            isDeviating: true,
            deviation: 8.3,
            onToggle: {}
        )
    }
}

