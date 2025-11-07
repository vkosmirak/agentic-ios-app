//
//  CompassRoseView.swift
//  AgenticCompas
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import SwiftUI

/// View displaying the compass rose with cardinal directions
struct CompassRoseView: View {
    let heading: Double
    let bearingLock: BearingLock?
    let isDeviating: Bool
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let radius = size / 2
            
            ZStack {
                // Compass rose background circle
                Circle()
                    .fill(Color(.systemBackground))
                    .overlay(
                        Circle()
                            .stroke(Color.primary.opacity(0.2), lineWidth: 2)
                    )
                
                // Cardinal directions
                ForEach(0..<8) { index in
                    let angle = Double(index) * 45.0 - 90.0 // Start from North
                    let direction = cardinalDirection(for: index)
                    
                    VStack(spacing: 4) {
                        Text(direction.letter)
                            .font(.system(size: size * 0.08, weight: .bold))
                            .foregroundColor(direction.isPrimary ? .primary : .secondary)
                        
                        Text(direction.name)
                            .font(.system(size: size * 0.04))
                            .foregroundColor(.secondary)
                    }
                    .offset(y: -radius * 0.7)
                    .rotationEffect(.degrees(angle))
                }
                
                // Bearing lock indicator (red band)
                if let lock = bearingLock, isDeviating {
                    let bandWidth: CGFloat = 8
                    
                    // Red band showing deviation
                    Rectangle()
                        .fill(Color.red.opacity(0.6))
                        .frame(width: bandWidth)
                        .offset(y: -radius * 0.9)
                        .rotationEffect(.degrees(heading - lock.bearing))
                }
                
                // North indicator arrow
                Triangle()
                    .fill(Color.red)
                    .frame(width: size * 0.1, height: size * 0.15)
                    .offset(y: -radius * 0.85)
                    .rotationEffect(.degrees(heading))
            }
            .rotationEffect(.degrees(-heading))
        }
    }
    
    private func cardinalDirection(for index: Int) -> (letter: String, name: String, isPrimary: Bool) {
        switch index {
        case 0: return ("N", "North", true)
        case 1: return ("NE", "Northeast", false)
        case 2: return ("E", "East", true)
        case 3: return ("SE", "Southeast", false)
        case 4: return ("S", "South", true)
        case 5: return ("SW", "Southwest", false)
        case 6: return ("W", "West", true)
        case 7: return ("NW", "Northwest", false)
        default: return ("", "", false)
        }
    }
}

/// Triangle shape for north indicator
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    CompassRoseView(heading: 45, bearingLock: nil, isDeviating: false)
        .frame(width: 300, height: 300)
}

