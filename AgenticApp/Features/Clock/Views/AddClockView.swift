//
//  AddClockView.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import SwiftUI

/// View for adding a new clock
struct AddClockView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText: String = ""
    
    let existingClocks: [ClockModel]
    let onSave: (ClockModel) -> Void
    
    private var filteredCities: [City] {
        if searchText.isEmpty {
            return City.allCities
        }
        return City.allCities.filter { city in
            city.name.localizedCaseInsensitiveContains(searchText) ||
            city.timeZoneIdentifier.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    /// Pre-computed set of existing city+timezone pairs for efficient lookup
    private var existingClockKeys: Set<String> {
        Set(existingClocks.map { "\($0.cityName):\($0.timeZone.identifier)" })
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredCities) { city in
                    Button {
                        guard !city.name.isEmpty else { return }
                        
                        let clock = ClockModel(
                            cityName: city.name,
                            timeZoneIdentifier: city.timeZoneIdentifier
                        )
                        onSave(clock)
                        dismiss()
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(city.name)
                                    .foregroundColor(.primary)
                                    .font(.body)
                                
                                Text(city.region)
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                            
                            Spacer()
                            
                            if existingClockKeys.contains("\(city.name):\(city.timeZoneIdentifier)") {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search cities")
            .navigationTitle("Add Clock")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddClockView(
        existingClocks: [],
        onSave: { clock in
            print("Saved: \(clock)")
        }
    )
}

