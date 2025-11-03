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
    
    let alarm: AlarmModel?
    let onSave: (AlarmModel) -> Void
    
    init(alarm: AlarmModel? = nil, onSave: @escaping (AlarmModel) -> Void) {
        self.alarm = alarm
        self.onSave = onSave
        
        let values = alarm.map(InitialValues.from) ?? InitialValues.defaults()
        _time = State(initialValue: values.time)
        _label = State(initialValue: values.label)
        _repeatDays = State(initialValue: values.repeatDays)
        _sound = State(initialValue: values.sound)
        _snooze = State(initialValue: values.snooze)
    }
    
    /// Helper struct for initial values
    private struct InitialValues {
        let time: Date
        let label: String
        let repeatDays: Set<Weekday>
        let sound: String
        let snooze: Bool
        
        static func from(_ alarm: AlarmModel) -> InitialValues {
            InitialValues(
                time: alarm.time,
                label: alarm.label ?? "",
                repeatDays: alarm.repeatDays,
                sound: alarm.sound,
                snooze: alarm.snooze
            )
        }
        
        static func defaults() -> InitialValues {
            InitialValues(
                time: Self.nextRoundedTime(),
                label: "",
                repeatDays: [],
                sound: "Radar",
                snooze: true
            )
        }
        
        private static func nextRoundedTime() -> Date {
            let calendar = Calendar.current
            let now = Date()
            let minutes = calendar.component(.minute, from: now)
            let roundedMinutes = ((minutes / 5) + 1) * 5
            let minutesToAdd = roundedMinutes - minutes
            return calendar.date(byAdding: .minute, value: minutesToAdd, to: now) ?? now
        }
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
            .navigationTitle(alarm == nil ? "Add Alarm" : "Edit Alarm")
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
            id: alarm?.id ?? UUID(),
            time: time,
            label: label.isEmpty ? nil : label,
            isEnabled: alarm?.isEnabled ?? true,
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

