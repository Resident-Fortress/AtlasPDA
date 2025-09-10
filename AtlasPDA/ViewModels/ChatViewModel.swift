//
//  ChatViewModel.swift
//  AtlasPDA
//
//  Created by Matthew Dudzinski on 9/9/25.
//

import SwiftUI
import FoundationModels

@MainActor
class ChatViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var session = LanguageModelSession() {
        """
        You're a Personal Assistant, you help users manage dates in a calendar, give suggestions when asked, and give recommendations based on user interests. You will ask questions that help you learn more about the user and are not allowed to give any harmful information or suggestions to the user
        """
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
                    print(response)
                }
            }
            catch let error as LanguageModelSession.GenerationError {
                print(error.localizedDescription)
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}