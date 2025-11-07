//
//  NorthType.swift
//  AgenticCompas
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import Foundation

/// Type of north reference
enum NorthType: Equatable, @unchecked Sendable {
    case magnetic
    case `true`
    
    var displayName: String {
        switch self {
        case .magnetic:
            return "Magnetic"
        case .`true`:
            return "True"
        }
    }
}

