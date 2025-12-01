# AtlasPDA

**AtlasPDA** is a SwiftUI-based personal assistant app that leverages Apple's `FoundationModels` to interact with users through natural language. It helps users manage dates, gives personalized suggestions, and provides recommendations based on user interests.

---

## Features

* **Conversational AI Assistant**
  Communicate naturally with the AI, which can respond with suggestions, reminders, or recommendations.

* **Session-Based Conversation**
  Maintains a transcript of prompts and responses, allowing context-aware interactions.

* **Interactive UI**

  * Dynamic message list with clear separation between user messages and assistant responses.
  * Input field with adaptive height and a send button.
  * Smooth transitions and animations for messages.

* **System Language Model Integration**
  Automatically detects if the device supports Apple’s language model features and provides guidance if unavailable.

---

## Requirements

* iOS 17 or later
* Swift 5.9+
* Apple device eligible for **Apple Intelligence** features

---

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/AtlasPDA.git
   ```
2. Open the project in Xcode.
3. Build and run on a compatible device or simulator.

---

## Usage

1. Launch the app.
2. Type a message in the input field at the bottom.
3. Press **Send** to interact with the AI.
4. The assistant responds in real-time and updates the conversation transcript.

**Note:** The language model will prewarm on launch to reduce response time. If unavailable, the app provides instructions to enable or access the model.

---

## Code Structure

* `ContentView.swift`

  * Main view containing the conversation list and input field.
  * Handles session management and streaming responses from the language model.

* `SavedMessage`

  * Codable struct for storing messages with unique identifiers.

* `SegmentsView`

  * Handles rendering of individual transcript segments, distinguishing between user and assistant messages.

---

## Limitations

* The AI only provides helpful, safe recommendations and will not provide harmful advice.
* Apple Intelligence must be enabled and ready for the app to function fully.

---

## Contributing

Contributions are welcome! Feel free to submit pull requests for improvements, additional features, or bug fixes.

---

## License

MIT License © 2025
