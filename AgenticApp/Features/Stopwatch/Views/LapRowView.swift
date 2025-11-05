//
//  LapRowView.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import SwiftUI

/// Row view for displaying a lap time
struct LapRowView: View {
    let lap: Lap
    let isFastest: Bool
    let isSlowest: Bool
    
    var body: some View {
        HStack {
            Text("Lap \(lap.lapNumber)")
                .font(.system(size: 17))
                .foregroundColor(lapColor)
            
            Spacer()
            
            Text(lap.formattedLapTime)
                .font(.system(size: 17))
                .foregroundColor(lapColor)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Lap \(lap.lapNumber), \(lap.formattedLapTime)")
        .accessibilityHint(isFastest ? "Fastest lap" : isSlowest ? "Slowest lap" : "")
        
        Divider()
            .padding(.leading, 16)
    }
    
    private var lapColor: Color {
        if isFastest {
            return .green
        } else if isSlowest {
            return .red
        } else {
            return .primary
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        LapRowView(
            lap: Lap(lapNumber: 1, time: 2.01, lapTime: 2.01),
            isFastest: false,
            isSlowest: false
        )
        
        LapRowView(
            lap: Lap(lapNumber: 2, time: 2.56, lapTime: 0.55),
            isFastest: true,
            isSlowest: false
        )
        
        LapRowView(
            lap: Lap(lapNumber: 3, time: 13.27, lapTime: 10.71),
            isFastest: false,
            isSlowest: true
        )
    }
    .background(Color(.systemGroupedBackground))
}

