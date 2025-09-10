//
//  ChatViewModel.swift
//  AtlasPDA
//
//  Created by Matthew Dudzinski on 9/9/25.
//

import SwiftUI
import FoundationModels
internal import Combine

// MARK: - Chat ViewModel
@MainActor
class ChatViewModel: ObservableObject {
    @Published var inputText: String = ""

    @Published var session: LanguageModelSession

    init() {
        session = LanguageModelSession(
            tools: [CalendarTool(), CalendarReadTool()] // Inject Calendar tools
        ) {
            """
            You are Atlas (Assistant for Tasks, Learning, and Scheduling), a Personal Assistant.
            - Help the user manage dates and schedule events using the Calendar tool.
            - Provide suggestions and recommendations when asked.
            - Ask questions to learn more about the user.
            - Do not provide harmful content.
            
            When creating a calendar event, you **must only return JSON** in this format:

            {
              "title": "Event Title",
              "date": "2025-09-10T15:00:00Z"
            }

            Do not include any extra text or explanation. Use **UTC ISO8601 format** for the date.
            """
        }
    }
    
    var isSystemAvailable: Bool {
        if case .available = SystemLanguageModel.default.availability {
            return true
        }
        return false
    }
    
    var unavailabilityReason: String {
        if case .unavailable(let reason) = SystemLanguageModel.default.availability {
            return switch reason {
            case .appleIntelligenceNotEnabled:
                "Apple Intelligence is not enabled. Please enable it in Settings."
            case .deviceNotEligible:
                "This device is not eligible for Apple Intelligence. Please use a compatible device."
            case .modelNotReady:
                "The language model is not ready yet. Please try again later."
            @unknown default:
                "The language model is unavailable for an unknown reason."
            }
        }
        return "Unknown error"
    }
    
    func prewarmSession() {
        session.prewarm()
    }
    
    func sendMessage() {
        Task {
            do {
                let prompt = inputText
                inputText = ""
                let stream = session.streamResponse(to: prompt)

                for try await response in stream {
                    print("Assistant: \(response.content)") // The model’s reply
                }
            }
            catch let error as LanguageModelSession.GenerationError {
                print("⚠️ Generation error: \(error.localizedDescription)")
            }
            catch {
                print("⚠️ Error: \(error.localizedDescription)")
            }
        }
    }
}
