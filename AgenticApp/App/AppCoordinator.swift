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
    private let stopwatchCoordinator: StopwatchCoordinator
    
    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
        self.clockCoordinator = ClockCoordinator(dependencyContainer: dependencyContainer)
        self.alarmsCoordinator = AlarmsCoordinator(dependencyContainer: dependencyContainer)
        self.timersCoordinator = TimersCoordinator(dependencyContainer: dependencyContainer)
        self.stopwatchCoordinator = StopwatchCoordinator(dependencyContainer: dependencyContainer)
    }
    
    func start() {
        clockCoordinator.start()
        alarmsCoordinator.start()
        timersCoordinator.start()
        stopwatchCoordinator.start()
        addChild(clockCoordinator)
        addChild(alarmsCoordinator)
        addChild(timersCoordinator)
        addChild(stopwatchCoordinator)
    }
    
    @ViewBuilder
    func rootView() -> some View {
        TabViewContainerView(
            clockView: AnyView(clockCoordinator.rootView()),
            alarmsView: AnyView(alarmsCoordinator.rootView()),
            timersView: AnyView(timersCoordinator.rootView()),
            stopwatchView: AnyView(stopwatchCoordinator.rootView())
        )
    }
}

/// Container view for TabView with proper accessibility support
private struct TabViewContainerView: View {
    let clockView: AnyView
    let alarmsView: AnyView
    let timersView: AnyView
    let stopwatchView: AnyView
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
            
            stopwatchView
                .tabItem {
                    Label("Stopwatch", systemImage: "stopwatch")
                        .accessibilityIdentifier("StopwatchTab")
                        .accessibilityLabel("Stopwatch")
                }
                .tag(3)
        }
    }
}

