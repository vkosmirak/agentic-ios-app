//
//  ClockView.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import SwiftUI

/// Main view for the Clock feature - World Clock
struct ClockView: View {
    @ObservedObject var viewModel: ClockViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.clocks) { clock in
                    ClockRowView(
                        clock: clock,
                        currentTime: viewModel.formattedTime(for: clock),
                        timeDifference: viewModel.timeDifference(for: clock)
                    )
                    .listRowSeparator(.hidden, edges: .all)
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                }
            }
            .listStyle(.plain)
            .navigationTitle("World Clock")
            .navigationBarTitleDisplayMode(.large)
            .lifecycle(viewModel)
        }
    }
}

#Preview {
    ClockView(viewModel: ClockViewModel(timeService: TimeService()))
}
