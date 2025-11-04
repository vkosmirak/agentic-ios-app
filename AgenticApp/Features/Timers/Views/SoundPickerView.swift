//
//  SoundPickerView.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import SwiftUI

/// View for selecting timer sound
struct SoundPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedSound: String
    
    let sounds = ["Radar", "Waves", "Cosmic", "Stargaze", "Evening Fairy Tale"]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(sounds, id: \.self) { sound in
                    Button {
                        selectedSound = sound
                        dismiss()
                    } label: {
                        HStack {
                            Text(sound)
                                .foregroundColor(.primary)
                            Spacer()
                            if selectedSound == sound {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("When Timer Ends")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SoundPickerView(selectedSound: .constant("Radar"))
}

