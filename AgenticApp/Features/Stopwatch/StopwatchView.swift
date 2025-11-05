//
//  StopwatchView.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import SwiftUI

/// Main view for the Stopwatch feature
struct StopwatchView: View {
    @ObservedObject var viewModel: StopwatchViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Time display
                    timeDisplayView
                        .padding(.vertical, 40)
                    
                    // Control buttons
                    controlButtonsView
                        .padding(.bottom, 32)
                    
                    // Lap list
                    if !viewModel.laps.isEmpty {
                        lapListView
                    }
                }
            }
            .navigationTitle("Stopwatch")
            .navigationBarTitleDisplayMode(.large)
            .lifecycle(viewModel)
        }
    }
    
    // MARK: - Time Display
    
    private var timeDisplayView: some View {
        Text(viewModel.formattedTime)
            .font(.system(size: 96, weight: .thin, design: .rounded))
            .foregroundColor(.primary)
            .monospacedDigit()
    }
    
    // MARK: - Control Buttons
    
    private var controlButtonsView: some View {
        HStack(spacing: 20) {
            // Lap/Reset button
            Button {
                if viewModel.isRunning {
                    viewModel.lap()
                } else {
                    viewModel.reset()
                }
            } label: {
                Text(viewModel.isRunning ? "Lap" : viewModel.laps.isEmpty ? "Lap" : "Reset")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(viewModel.isRunning || !viewModel.laps.isEmpty ? .primary : .secondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        Circle()
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1.5)
                            .fill(viewModel.isRunning || !viewModel.laps.isEmpty ? Color.clear : Color.secondary.opacity(0.1))
                    )
            }
            .disabled(!viewModel.isRunning && viewModel.laps.isEmpty)
            .accessibilityLabel(viewModel.isRunning ? "Record lap time" : "Reset stopwatch")
            .accessibilityHint(viewModel.isRunning ? "Records the current lap time" : "Resets the stopwatch to zero and clears all laps")
            
            // Start/Stop button
            Button {
                if viewModel.isRunning {
                    viewModel.stop()
                } else {
                    viewModel.start()
                }
            } label: {
                Text(viewModel.isRunning ? "Stop" : "Start")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        Circle()
                            .fill(viewModel.isRunning ? Color.red : Color.green)
                    )
            }
            .accessibilityLabel(viewModel.isRunning ? "Stop stopwatch" : "Start stopwatch")
            .accessibilityHint(viewModel.isRunning ? "Pauses the stopwatch timer" : "Starts the stopwatch timer")
        }
        .padding(.horizontal, 32)
    }
    
    // MARK: - Lap List
    
    private var lapListView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider()
            
            ForEach(viewModel.laps.reversed()) { lap in
                LapRowView(
                    lap: lap,
                    isFastest: lap.id == viewModel.fastestLap?.id,
                    isSlowest: lap.id == viewModel.slowestLap?.id
                )
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    StopwatchView(viewModel: StopwatchViewModel(stopwatchService: StopwatchService()))
}

