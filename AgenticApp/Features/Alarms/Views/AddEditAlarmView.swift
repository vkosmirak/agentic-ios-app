//
//  AddEditAlarmView.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import SwiftUI

/// View for adding or editing an alarm
struct AddEditAlarmView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var time: Date
    @State private var label: String
    @State private var repeatDays: Set<Weekday>
    @State private var sound: String
    @State private var snooze: Bool
    
    let alarm: AlarmModel
    let isNewAlarm: Bool
    let onSave: (AlarmModel) -> Void
    
    init(alarm: AlarmModel = .default, onSave: @escaping (AlarmModel) -> Void) {
        self.alarm = alarm
        self.isNewAlarm = (alarm == .default)
        self.onSave = onSave
        
        _time = State(initialValue: alarm.time)
        _label = State(initialValue: alarm.label ?? "")
        _repeatDays = State(initialValue: alarm.repeatDays)
        _sound = State(initialValue: alarm.sound)
        _snooze = State(initialValue: alarm.snooze)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                
                Section {
                    TextField("Label", text: $label)
                        .textInputAutocapitalization(.words)
                }
                
                Section {
                    ForEach(Weekday.allCases) { weekday in
                        Button {
                            if repeatDays.contains(weekday) {
                                repeatDays.remove(weekday)
                            } else {
                                repeatDays.insert(weekday)
                            }
                        } label: {
                            HStack {
                                Text(weekday.fullName)
                                    .foregroundColor(.primary)
                                Spacer()
                                if repeatDays.contains(weekday) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                } header: {
                    Text("Repeat")
                }
                
                Section {
                    Picker("Sound", selection: $sound) {
                        Text("Radar").tag("Radar")
                        Text("Waves").tag("Waves")
                        Text("Cosmic").tag("Cosmic")
                        Text("Stargaze").tag("Stargaze")
                    }
                    
                    Toggle("Snooze", isOn: $snooze)
                }
            }
            .navigationTitle(isNewAlarm ? "Add Alarm" : "Edit Alarm")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveAlarm()
                    }
                }
            }
        }
    }
    
    private func saveAlarm() {
        let alarmToSave = AlarmModel(
            id: isNewAlarm ? UUID() : alarm.id,
            time: time,
            label: label.isEmpty ? nil : label,
            isEnabled: alarm.isEnabled,
            repeatDays: repeatDays,
            sound: sound,
            snooze: snooze
        )
        onSave(alarmToSave)
        dismiss()
    }
}

#Preview {
    AddEditAlarmView { alarm in
        print("Saved: \(alarm)")
    }
}

