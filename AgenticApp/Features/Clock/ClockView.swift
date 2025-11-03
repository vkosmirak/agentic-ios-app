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
    @State private var showingAddClock = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.clocks.isEmpty {
                    emptyStateView
                } else {
                    clocksListView
                }
            }
            .navigationTitle("World Clock")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddClock = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddClock) {
                AddClockView(existingClocks: viewModel.clocks) { clock in
                    viewModel.addClock(clock)
                }
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }
            .lifecycle(viewModel)
        }
    }
    
    private var clocksListView: some View {
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
            .onDelete { indexSet in
                let clocksToDelete = indexSet.compactMap { index in
                    index < viewModel.clocks.count ? viewModel.clocks[index] : nil
                }
                viewModel.deleteClocks(clocksToDelete)
            }
        }
        .listStyle(.plain)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock.fill")
                .font(.system(size: 64))
                .foregroundColor(.secondary)
            
            Text("No Clocks")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Text("Tap + to add a world clock")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ClockView(viewModel: ClockViewModel(timeService: TimeService(), clockService: ClockService()))
}
