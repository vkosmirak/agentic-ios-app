//
//  AlarmsView.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import SwiftUI

/// Main view for the Alarms feature
struct AlarmsView: View {
    @ObservedObject var viewModel: AlarmsViewModel
    @State private var showingAddAlarm = false
    @State private var editingAlarm: AlarmModel?
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.alarms.isEmpty {
                    emptyStateView
                } else {
                    alarmsListView
                }
            }
            .navigationTitle("Alarms")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddAlarm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddAlarm) {
                AddEditAlarmView { alarm in
                    viewModel.addAlarm(alarm)
                }
            }
            .sheet(item: $editingAlarm) { alarm in
                AddEditAlarmView(alarm: alarm) { updatedAlarm in
                    viewModel.updateAlarm(updatedAlarm)
                }
            }
            .lifecycle(viewModel)
        }
    }
    
    private var alarmsListView: some View {
        List {
            ForEach(viewModel.alarms) { alarm in
                AlarmRowView(alarm: alarm) {
                    viewModel.toggleAlarm(alarm)
                }
                .listRowSeparator(.hidden, edges: .all)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .contentShape(Rectangle())
                .onTapGesture {
                    editingAlarm = alarm
                }
            }
            .onDelete { indexSet in
                let alarmsToDelete = indexSet.compactMap { index in
                    index < viewModel.alarms.count ? viewModel.alarms[index] : nil
                }
                for alarm in alarmsToDelete {
                    viewModel.deleteAlarm(alarm)
                }
            }
            
            Section {
                EmptyView()
            } footer: {
                Text("гімн україни")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 8)
            }
        }
        .listStyle(.plain)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "alarm.fill")
                .font(.system(size: 64))
                .foregroundColor(.secondary)
            
            Text("No Alarms")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Text("Tap + to add an alarm")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    AlarmsView(viewModel: AlarmsViewModel(alarmService: AlarmService()))
}
