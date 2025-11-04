//
//  TimersView.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import SwiftUI

/// Main view for the Timers feature (Apple Clock style)
struct TimersView: View {
    @ObservedObject var viewModel: TimersViewModel
    
    @State private var selectedHours: Int = 0
    @State private var selectedMinutes: Int = 5
    @State private var selectedSeconds: Int = 0
    @State private var timerLabel: String = "Timer"
    @State private var selectedSound: String = "Radar"
    @State private var showingSoundPicker = false
    @State private var showingNameEditor = false
    @State private var editingTimerLabel: String = "Timer"
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    if let activeTimer = viewModel.activeTimer {
                        // Active timer view (when timer is running)
                        activeTimerView
                    } else {
                        // Timer picker view (when no timer is running)
                        timerPickerView
                    }
                    
                    // Settings section
                    settingsSection
                    
                    // Recent timers section
                    if !viewModel.recentTimers.isEmpty {
                        recentTimersSection
                    }
                }
            }
            .navigationTitle("Timers")
            .navigationBarTitleDisplayMode(.large)
            .lifecycle(viewModel)
            .sheet(isPresented: $showingSoundPicker) {
                SoundPickerView(selectedSound: $selectedSound)
            }
            .sheet(isPresented: $showingNameEditor) {
                NavigationStack {
                    Form {
                        TextField("Timer Name", text: $editingTimerLabel)
                            .textInputAutocapitalization(.words)
                    }
                    .navigationTitle("Timer Name")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                showingNameEditor = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                if editingTimerLabel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    timerLabel = "Timer"
                                } else {
                                    timerLabel = editingTimerLabel.trimmingCharacters(in: .whitespacesAndNewlines)
                                }
                                showingNameEditor = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Timer Picker View
    
    private var timerPickerView: some View {
        VStack(spacing: 32) {
            // Timer picker wheels
            HStack(spacing: 8) {
                Picker("Hours", selection: $selectedHours) {
                    ForEach(0..<24) { hour in
                        Text("\(hour)").tag(hour)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)
                
                Text("hr")
                    .font(.system(size: 17))
                    .foregroundColor(.secondary)
                
                Picker("Minutes", selection: $selectedMinutes) {
                    ForEach(0..<60) { minute in
                        Text("\(minute)").tag(minute)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)
                
                Text("min")
                    .font(.system(size: 17))
                    .foregroundColor(.secondary)
                
                Picker("Seconds", selection: $selectedSeconds) {
                    ForEach(0..<60) { second in
                        Text("\(second)").tag(second)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)
                
                Text("sec")
                    .font(.system(size: 17))
                    .foregroundColor(.secondary)
            }
            .frame(height: 216)
            
            // Action buttons
            HStack(spacing: 20) {
                Button {
                    resetPicker()
                } label: {
                    Text("Reset")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            Circle()
                                .stroke(Color.secondary.opacity(0.3), lineWidth: 1.5)
                        )
                }
                
                Button {
                    startTimer()
                } label: {
                    Text("Start")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            Circle()
                                .fill(currentDuration > 0 ? Color.green : Color.gray)
                        )
                }
                .disabled(currentDuration == 0)
            }
            .padding(.horizontal, 32)
        }
        .padding(.vertical, 40)
    }
    
    // MARK: - Active Timer View
    
    @ViewBuilder
    private var activeTimerView: some View {
        if let timer = viewModel.activeTimer {
            VStack(spacing: 32) {
                // Countdown display
                Text(timer.formattedRemainingTime)
                    .font(.system(size: 96, weight: .thin, design: .rounded))
                    .foregroundColor(.primary)
                
                // Action buttons
                HStack(spacing: 20) {
                    Button {
                        viewModel.cancelActiveTimer()
                    } label: {
                        Text("Cancel")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                Circle()
                                    .stroke(Color.secondary.opacity(0.3), lineWidth: 1.5)
                            )
                    }
                    
                    Button {
                        if timer.isRunning {
                            viewModel.pauseActiveTimer()
                        } else {
                            viewModel.resumeActiveTimer()
                        }
                    } label: {
                        Text(timer.isRunning ? "Pause" : "Resume")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                Circle()
                                    .fill(Color.green)
                            )
                    }
                }
                .padding(.horizontal, 32)
            }
            .padding(.vertical, 40)
        }
    }
    
    // MARK: - Settings Section
    
    private var settingsSection: some View {
        VStack(spacing: 0) {
            Divider()
            
            Button {
                editingTimerLabel = timerLabel
                showingNameEditor = true
            } label: {
                HStack {
                    Text("Name")
                        .foregroundColor(.primary)
                    Spacer()
                    Text(timerLabel)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            
            Divider()
                .padding(.leading, 16)
            
            Button {
                showingSoundPicker = true
            } label: {
                HStack {
                    Text("When Timer Ends")
                        .foregroundColor(.primary)
                    Spacer()
                    Text(selectedSound)
                        .foregroundColor(.secondary)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            
            Divider()
        }
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - Recent Timers Section
    
    private var recentTimersSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider()
            
            Text("Recent")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            
            ForEach(viewModel.recentTimers) { timer in
                RecentTimerRowView(timer: timer) {
                    viewModel.startTimerFromRecent(timer)
                }
            }
        }
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - Helpers
    
    private var currentDuration: TimeInterval {
        TimeInterval(selectedHours * 3600 + selectedMinutes * 60 + selectedSeconds)
    }
    
    private func resetPicker() {
        selectedHours = 0
        selectedMinutes = 5
        selectedSeconds = 0
    }
    
    private func startTimer() {
        guard currentDuration > 0 else { return }
        
        let timer = TimerModel(
            duration: currentDuration,
            label: timerLabel == "Timer" ? nil : timerLabel,
            sound: selectedSound
        )
        viewModel.startNewTimer(timer)
    }
}

#Preview {
    TimersView(viewModel: TimersViewModel(timerService: TimerService()))
}
