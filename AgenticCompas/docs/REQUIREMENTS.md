# iPhone Compass App Clone - Requirements Document

## 1. Core Functional Requirements

### 1.1 Compass Functionality
- **Magnetic North Display**: Show device heading relative to magnetic north using magnetometer
- **True North Display**: Option to switch between magnetic north and true north
- **Heading Display**: Display current heading in degrees (0-360°)
- **Compass Rose**: Animated compass rose that rotates based on device orientation
- **Direction Indicators**: Show cardinal directions (N, S, E, W) and intercardinal directions (NE, SE, SW, NW)
- **Real-time Updates**: Continuously update compass reading as device orientation changes

### 1.2 Location Information
- **Coordinates Display**: Show current latitude and longitude
- **Elevation Display**: Show current elevation above sea level
- **Location Accuracy**: Display location accuracy indicator
- **Maps Integration**: Tap coordinates to open location in Maps app

### 1.3 Bearing Lock Feature
- **Lock Direction**: Allow user to lock a specific bearing/direction
- **Deviation Indicator**: Show red band/indicator when deviating from locked bearing
- **Unlock**: Ability to unlock and reset bearing
- **Visual Feedback**: Clear visual indication of locked state

### 1.4 Calibration
- **Calibration Prompt**: Prompt user to calibrate compass when accuracy is low
- **Figure-8 Motion**: Guide user through figure-8 calibration motion
- **Calibration Status**: Display calibration status/accuracy level
- **Auto-calibration**: Automatic calibration when possible

## 2. Technical Requirements

### 2.1 iOS Frameworks & APIs
- **CoreLocation**: For location services (coordinates, elevation, heading)
- **CoreMotion**: For device motion data (accelerometer, gyroscope)
- **MapKit**: For Maps app integration
- **SwiftUI**: For UI implementation
- **Combine**: For reactive state management

### 2.2 Hardware Access
- **Magnetometer**: Required for compass functionality
- **GPS**: Required for location and elevation data
- **Accelerometer**: For device tilt detection
- **Gyroscope**: For orientation tracking

### 2.3 Permissions
- **Location Services**: Request "When In Use" location permission
- **Privacy**: Comply with Apple's privacy guidelines
- **Permission Handling**: Gracefully handle denied permissions with user guidance

### 2.4 Performance Requirements
- **Battery Optimization**: Efficient sensor usage to minimize battery drain
- **Update Frequency**: Optimize sensor update frequency (e.g., 1-10 Hz for compass)
- **Background Operation**: Handle app backgrounding appropriately

### 2.5 Error Handling
- **Magnetic Interference**: Detect and warn about magnetic interference
- **Location Unavailable**: Handle cases where location services are unavailable
- **Sensor Unavailable**: Handle devices without required sensors
- **Permission Denied**: Provide clear guidance when permissions are denied

## 3. UI/UX Requirements

### 3.1 Main Compass View
- **Compass Rose**: Large, centered compass rose with cardinal directions
- **Heading Display**: Prominent display of current heading in degrees
- **Coordinates**: Display latitude/longitude (tappable to open Maps)
- **Elevation**: Display elevation below coordinates
- **North Indicator**: Clear indication of north direction
- **Bearing Lock Button**: Button to lock/unlock bearing

### 3.2 Visual Design
- **Minimalist Design**: Clean, uncluttered interface
- **High Contrast**: Ensure readability in various lighting conditions
- **Dark Mode Support**: Support both light and dark appearance
- **Accessibility**: VoiceOver support, Dynamic Type, accessibility labels

### 3.3 Animations
- **Smooth Rotation**: Smooth compass rose rotation as heading changes
- **Transition Animations**: Smooth transitions between states
- **Haptic Feedback**: Optional haptic feedback for bearing lock/unlock

### 3.4 Settings/Options
- **North Type Toggle**: Switch between magnetic and true north
- **Units**: Option for elevation units (meters/feet)
- **Calibration**: Manual calibration trigger

## 4. Architecture Implementation

### 4.1 Feature Structure (MVVM-C)
```
AgenticCompas/
├── Features/
│   └── Compass/
│       ├── CompassView.swift
│       ├── CompassViewModel.swift
│       ├── CompassCoordinator.swift
│       ├── Models/
│       │   ├── CompassReading.swift
│       │   ├── LocationData.swift
│       │   └── BearingLock.swift
│       └── Views/
│           ├── CompassRoseView.swift
│           ├── CoordinatesView.swift
│           └── BearingLockView.swift
```

### 4.2 Services Layer
```
Core/Services/
├── Location/
│   ├── LocationServiceProtocol.swift
│   └── LocationService.swift
├── Compass/
│   ├── CompassServiceProtocol.swift
│   └── CompassService.swift
└── Calibration/
    ├── CalibrationServiceProtocol.swift
    └── CalibrationService.swift
```

### 4.3 Service Responsibilities
- **LocationService**: Handle CLLocationManager, location updates, coordinates, elevation
- **CompassService**: Handle heading updates, magnetic/true north conversion
- **CalibrationService**: Manage calibration state, accuracy assessment

### 4.4 Models
- **CompassReading**: Heading (degrees), accuracy, timestamp
- **LocationData**: Latitude, longitude, elevation, accuracy
- **BearingLock**: Locked bearing value, deviation angle

## 5. Implementation Details

### 5.1 CoreLocation Integration
- Use `CLLocationManager` for location and heading
- Implement `CLLocationManagerDelegate` for updates
- Handle authorization states (notDetermined, authorized, denied)
- Request appropriate accuracy level

### 5.2 Compass Calculations
- Convert magnetic heading to true north using magnetic declination
- Handle heading accuracy and filtering
- Implement smoothing algorithm for stable readings

### 5.3 Bearing Lock Logic
- Store locked bearing value
- Calculate deviation angle from current heading
- Display visual indicator (red band) when deviation exceeds threshold
- Reset lock when user unlocks

### 5.4 Calibration Detection
- Monitor heading accuracy
- Detect when calibration is needed (low accuracy)
- Trigger calibration UI when necessary
- Track calibration status

## 6. Testing Requirements

### 6.1 Unit Tests
- **CompassServiceTests**: Test heading calculations, magnetic/true north conversion
- **LocationServiceTests**: Test location updates, coordinate formatting
- **CompassViewModelTests**: Test state management, bearing lock logic
- **CalibrationServiceTests**: Test calibration detection and status

### 6.2 UI Tests
- **CompassViewUITests**: Verify compass display, rotation
- **BearingLockUITests**: Test lock/unlock functionality
- **CoordinatesUITests**: Test Maps integration
- **PermissionFlowUITests**: Test permission request flow

### 6.3 Integration Tests
- Test sensor data flow from services to ViewModel to View
- Test error handling scenarios
- Test permission denial scenarios

## 7. Privacy & Permissions

### 7.1 Info.plist Entries
- `NSLocationWhenInUseUsageDescription`: Explain why location is needed
- `NSLocationAlwaysAndWhenInUseUsageDescription`: If background location needed

### 7.2 Permission Flow
- Request permission at appropriate time (not on launch)
- Explain why permission is needed
- Handle all authorization states gracefully
- Provide settings link if permission denied

## 8. Additional Considerations

### 8.1 Optional Features (Future)
- **Level Tool**: Built-in level for measuring surface angles
- **Waypoints**: Mark and navigate to specific locations
- **Backtrack**: Record and retrace path
- **Compass History**: Track heading history

### 8.2 Edge Cases
- Device without magnetometer (show error message)
- Location services disabled (show guidance)
- Magnetic interference (warn user)
- Low battery mode (reduce update frequency)

### 8.3 Internationalization
- Support multiple languages
- Format coordinates according to locale
- Format elevation units (metric/imperial)

## 9. Success Criteria

- Compass accurately displays device heading
- Location coordinates and elevation are accurate
- Bearing lock works correctly with visual feedback
- App handles all error states gracefully
- UI is intuitive and matches iOS design guidelines
- App passes all unit and UI tests
- Battery usage is optimized
- Accessibility features work correctly

