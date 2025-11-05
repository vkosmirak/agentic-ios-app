//
//  AddEditTimerView.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import SwiftUI

/// View for adding or editing a timer
struct AddEditTimerView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var hours: Int = 0
    @State private var minutes: Int = 5
    @State private var seconds: Int = 0
    @State private var label: String = ""
    
    let timer: TimerModel
    let isNewTimer: Bool
    let onSave: (TimerModel) -> Void
    
    init(timer: TimerModel = .default, onSave: @escaping (TimerModel) -> Void) {
        self.timer = timer
        self.isNewTimer = (timer == .default)
        self.onSave = onSave
        
        let totalSeconds = Int(timer.duration)
        _hours = State(initialValue: totalSeconds / 3600)
        _minutes = State(initialValue: (totalSeconds % 3600) / 60)
        _seconds = State(initialValue: totalSeconds % 60)
        _label = State(initialValue: timer.label ?? "")
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Picker("Hours", selection: $hours) {
                            ForEach(0..<24) { hour in
                                Text("\(hour)").tag(hour)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxWidth: .infinity)
                        
                        Text(":")
                            .font(.title2)
                        
                        Picker("Minutes", selection: $minutes) {
                            ForEach(0..<60) { minute in
                                Text("\(minute)").tag(minute)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxWidth: .infinity)
                        
                        Text(":")
                            .font(.title2)
                        
                        Picker("Seconds", selection: $seconds) {
                            ForEach(0..<60) { second in
                                Text("\(second)").tag(second)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxWidth: .infinity)
                    }
                } header: {
                    Text("Duration")
                }
                
                Section {
                    TextField("Label", text: $label)
                        .textInputAutocapitalization(.words)
                } header: {
                    Text("Label")
                } footer: {
                    Text("Optional label for this timer")
                }
            }
            .navigationTitle(isNewTimer ? "Add Timer" : "Edit Timer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTimer()
                    }
                    .disabled(totalDuration == 0)
                }
            }
        }
    }
    
    private var totalDuration: TimeInterval {
        TimeInterval(hours * 3600 + minutes * 60 + seconds)
    }
    
    private func saveTimer() {
        guard totalDuration > 0 else { return }
        
        let timerToSave = TimerModel(
            id: isNewTimer ? UUID() : timer.id,
            duration: totalDuration,
            label: label.isEmpty ? nil : label,
            isRunning: timer.isRunning,
            remainingTime: timer.isRunning ? timer.remainingTime : totalDuration,
            endTime: timer.endTime
        )
        onSave(timerToSave)
        dismiss()
    }
}

#Preview {
    AddEditTimerView { timer in
        print("Saved: \(timer)")
    }
}


