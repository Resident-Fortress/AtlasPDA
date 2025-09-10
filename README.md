# AtlasPDA - MVVM Architecture & FoundationModels Integration

## Overview
AtlasPDA is a SwiftUI-based Personal Digital Assistant app that leverages Apple's FoundationModels framework for on-device AI capabilities. The app has been refactored to follow MVVM (Model-View-ViewModel) architecture principles.

## Architecture

### MVVM Structure

#### Models (`/Models`)
- **ChatModels.swift**: Contains data structures for the chat functionality
  - `SavedMessage`: Represents a chat message with ID, role, and content

#### ViewModels (`/ViewModels`)
- **ChatViewModel.swift**: Contains business logic and state management
  - Manages `LanguageModelSession` for AI interactions
  - Handles input text state
  - Provides computed properties for system availability
  - Contains message sending logic with error handling

#### Views (`/Views`)
- **ContentView.swift**: Main view container with system availability check
- **Components/SegmentsView.swift**: Displays individual message segments
- **Components/ChatInputView.swift**: Reusable input field component

## FoundationModels Integration

### System Requirements
- iOS 18.0+ (Project targets iOS 26.0)
- Compatible Apple Intelligence device
- Apple Intelligence enabled in Settings

### Implementation Details

#### Language Model Session
```swift
@Published var session = LanguageModelSession() {
    """
    You're a Personal Assistant, you help users manage dates in a calendar, 
    give suggestions when asked, and give recommendations based on user interests. 
    You will ask questions that help you learn more about the user and are not 
    allowed to give any harmful information or suggestions to the user
    """
}
```

#### Availability Checking
The app properly checks `SystemLanguageModel.default.availability` and handles different states:
- `.available`: Shows the chat interface
- `.unavailable(reason)`: Shows appropriate error message based on reason
  - `appleIntelligenceNotEnabled`
  - `deviceNotEligible` 
  - `modelNotReady`

#### Async Response Handling
```swift
let stream = session.streamResponse(to: prompt)
for try await response in stream {
    print(response)
}
```

#### Session Management
- `session.prewarm()`: Optimizes model loading
- `session.isResponding`: Tracks response state
- Proper error handling for `LanguageModelSession.GenerationError`

## Key Features

### Chat Interface
- Real-time streaming responses
- User/Assistant message differentiation
- Visual message alignment (user: right, assistant: left)
- Animated message transitions
- Input field with send button
- Disabled state during AI response

### Error Handling
- Graceful handling of model unavailability
- Specific error messages for different failure scenarios
- Network and generation error handling

### Performance Optimizations
- Model prewarming on view appearance
- Efficient state management with `@Published` properties
- Proper use of `@MainActor` for UI updates

## Code Quality Improvements

### Separation of Concerns
- ✅ Models handle data structures
- ✅ ViewModels manage business logic and state
- ✅ Views focus purely on UI presentation
- ✅ Components are reusable and focused

### SwiftUI Best Practices
- ✅ Proper use of `@StateObject` and `@ObservedObject`
- ✅ Binding patterns for data flow
- ✅ Closure-based event handling
- ✅ Modular view composition

### FoundationModels Best Practices
- ✅ Proper availability checking
- ✅ Async/await pattern usage
- ✅ Error handling for different failure modes
- ✅ Session prewarming for better performance
- ✅ Streaming response handling

## File Structure
```
AtlasPDA/
├── Models/
│   └── ChatModels.swift
├── ViewModels/
│   └── ChatViewModel.swift
├── Views/
│   └── Components/
│       ├── ChatInputView.swift
│       └── SegmentsView.swift
├── ContentView.swift
└── AtlasPDAApp.swift
```

This structure follows Apple's recommended patterns and provides a scalable foundation for future feature additions.