//
//  View+Extensions.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import SwiftUI

extension View {
    /// Applies onAppear and onDisappear lifecycle methods to ViewModels
    func lifecycle(_ viewModel: any ViewModel) -> some View {
        self.onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }
}

