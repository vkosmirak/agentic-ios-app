//
//  ClockRowView.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import SwiftUI

/// Row view for displaying a single clock
struct ClockRowView: View {
    let clock: ClockModel
    let currentTime: String
    let timeDifference: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(clock.cityName)
                    .font(.system(size: 34, weight: .light))
                    .foregroundColor(.primary)
                
                Text(timeDifference)
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(currentTime)
                .font(.system(size: 64, weight: .thin))
                .foregroundColor(.primary)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ClockRowView(
        clock: ClockModel(cityName: "New York", timeZoneIdentifier: "America/New_York"),
        currentTime: "3:45 PM",
        timeDifference: "3 hours ahead"
    )
    .padding()
}

