//
//  StopwatchView.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import SwiftUI

/// Main view for the Stopwatch feature (Apple Clock style)
struct StopwatchView: View {
    @ObservedObject var viewModel: StopwatchViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Time display
                VStack(spacing: 0) {
                    Text(viewModel.formattedCurrentElapsedTime)
                        .font(.system(size: 96, weight: .thin, design: .rounded))
                        .foregroundColor(.primary)
                        .monospacedDigit()
                        .padding(.top, 40)
                    
                    // Control buttons
                    HStack(spacing: 20) {
                        if viewModel.stopwatch.isRunning {
                            // Running state: Lap and Stop buttons
                            Button {
                                viewModel.recordLap()
                            } label: {
                                Text("Lap")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 80)
                                    .background(
                                        Circle()
                                            .fill(Color(.systemGray5))
                                    )
                            }
                            
                            Button {
                                viewModel.stop()
                            } label: {
                                Text("Stop")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 80)
                                    .background(
                                        Circle()
                                            .fill(Color.red)
                                    )
                            }
                        } else {
                            // Stopped state: Reset and Start buttons
                            if viewModel.stopwatch.elapsedTime > 0 {
                                Button {
                                    viewModel.reset()
                                } label: {
                                    Text("Reset")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(.primary)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 80)
                                        .background(
                                            Circle()
                                                .fill(Color(.systemGray5))
                                        )
                                }
                            } else {
                                // Empty state: just Start button
                                Spacer()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 80)
                            }
                            
                            Button {
                                viewModel.start()
                            } label: {
                                Text("Start")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 80)
                                    .background(
                                        Circle()
                                            .fill(Color.green)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 32)
                    .padding(.bottom, 40)
                }
                
                // Lap times list
                if !viewModel.stopwatch.laps.isEmpty {
                    Divider()
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            // Show laps in reverse order (most recent first)
                            ForEach(viewModel.stopwatch.laps.reversed()) { lap in
                                LapRowView(lap: lap)
                                
                                if lap.id != viewModel.stopwatch.laps.reversed().first?.id {
                                    Divider()
                                        .padding(.leading, 16)
                                }
                            }
                        }
                    }
                    .background(Color(.systemGroupedBackground))
                }
            }
            .navigationTitle("Stopwatch")
            .navigationBarTitleDisplayMode(.large)
            .lifecycle(viewModel)
        }
    }
}

#Preview {
    StopwatchView(viewModel: StopwatchViewModel(stopwatchService: StopwatchService()))
}

