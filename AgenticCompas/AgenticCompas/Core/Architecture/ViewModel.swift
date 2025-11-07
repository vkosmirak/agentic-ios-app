//
//  ViewModel.swift
//  AgenticCompas
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import Foundation
import Combine

/// Base protocol for ViewModels in MVVM-C architecture
protocol ViewModel: ObservableObject {
    /// Cancellables storage for Combine subscriptions
    var cancellables: Set<AnyCancellable> { get set }
    
    /// Called when view appears
    func onAppear()
    
    /// Called when view disappears
    func onDisappear()
}

extension ViewModel {
    /// Default implementation - can be overridden
    func onAppear() {}
    func onDisappear() {
        cancellables.removeAll()
    }
}

