//
//  LapRowView.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import SwiftUI

/// Row view for displaying a lap time
struct LapRowView: View {
    let lap: LapModel
    
    var body: some View {
        HStack {
            // Lap number
            Text("Lap \(lap.lapNumber)")
                .font(.system(size: 17))
                .foregroundColor(.primary)
            
            Spacer()
            
            // Lap time
            Text(lap.formattedLapTime)
                .font(.system(size: 17, design: .monospaced))
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    VStack {
        LapRowView(lap: LapModel(lapNumber: 1, lapTime: 45.23, totalTime: 45.23))
        LapRowView(lap: LapModel(lapNumber: 2, lapTime: 52.67, totalTime: 97.90))
    }
}

