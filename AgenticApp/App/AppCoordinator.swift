//
//  AppCoordinator.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import SwiftUI

/// Root coordinator for the app
final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let dependencyContainer: DependencyContainer
    private let clockCoordinator: ClockCoordinator
    private let alarmsCoordinator: AlarmsCoordinator
    private let timersCoordinator: TimersCoordinator
    
    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
        self.clockCoordinator = ClockCoordinator(dependencyContainer: dependencyContainer)
        self.alarmsCoordinator = AlarmsCoordinator(dependencyContainer: dependencyContainer)
        self.timersCoordinator = TimersCoordinator(dependencyContainer: dependencyContainer)
    }
    
    func start() {
        clockCoordinator.start()
        alarmsCoordinator.start()
        timersCoordinator.start()
        addChild(clockCoordinator)
        addChild(alarmsCoordinator)
        addChild(timersCoordinator)
    }
    
    @ViewBuilder
    func rootView() -> some View {
        TabViewContainerView(
            clockView: AnyView(clockCoordinator.rootView()),
            alarmsView: AnyView(alarmsCoordinator.rootView()),
            timersView: AnyView(timersCoordinator.rootView())
        )
    }
}

/// Container view for TabView with proper accessibility support
private struct TabViewContainerView: View {
    let clockView: AnyView
    let alarmsView: AnyView
    let timersView: AnyView
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            clockView
                .tabItem {
                    Label("World Clock", systemImage: "globe")
                        .accessibilityIdentifier("WorldClockTab")
                        .accessibilityLabel("World Clock")
                }
                .tag(0)
            
            alarmsView
                .tabItem {
                    Label("Alarms", systemImage: "alarm.fill")
                        .accessibilityIdentifier("AlarmsTab")
                        .accessibilityLabel("Alarms")
                }
                .tag(1)
            
            timersView
                .tabItem {
                    Label("Timers", systemImage: "timer")
                        .accessibilityIdentifier("TimersTab")
                        .accessibilityLabel("Timers")
                }
                .tag(2)
        }
    }
}

