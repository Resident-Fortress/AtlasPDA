//
//  ContentView.swift
//  AtlasPDA
//
//  Created by Matthew Dudzinski on 9/9/25.
//

import SwiftUI
import FoundationModels

struct SavedMessage: Identifiable, Codable {
    let id: UUID
    let role: String
    let content: String
}

struct ContentView: View {
    @State var inputText: String = ""
    @State var session = LanguageModelSession() {
        """
        You're a Personal Assistant, you help users manage dates in a calendar, give suggestions when asked, and give recommendations based on user interests. You will ask questions that help you learn more about the user and are not allowed to give any harmful information or suggestions to the user
        """
    }
    var body: some View {
           switch SystemLanguageModel.default.availability {
           case .available:
               List(session.transcript) { entry in
                   switch entry {
                   case .prompt(let prompt):
                       SegmentsView(segments: prompt.segments, isUser: true)
                           .listRowSeparator(.hidden)
                   case .response(let response):
                       SegmentsView(segments: response.segments, isUser: false)
                           .listRowSeparator(.hidden)
                   case .instructions, .toolCalls, .toolOutput:
                       EmptyView()
                   @unknown default:
                       EmptyView()
                   }
               }
               .listStyle(.plain)
               .safeAreaInset(edge: .bottom) {
                   HStack {
                       TextField("Type a message...", text: $inputText, axis: .vertical)
                           .textFieldStyle(.roundedBorder)
                           .disabled(session.isResponding)
                       Button("Send") {
                           sendMessage()
                       }
                       .disabled(inputText.isEmpty || session.isResponding)
                   }
                   .padding()
                   .background(Color(.systemBackground))
               }
               .onAppear {
                   session.prewarm()
               }
           case .unavailable(let reason):
               let text = switch reason {
               case .appleIntelligenceNotEnabled:
                   "Apple Intelligence is not enabled. Please enable it in Settings."
               case .deviceNotEligible:
                   "This device is not eligible for Apple Intelligence. Please use a compatible device."
               case .modelNotReady:
                   "The language model is not ready yet. Please try again later."
               @unknown default:
                   "The language model is unavailable for an unknown reason."
               }
               ContentUnavailableView(text, systemImage: "apple.intelligence.badge.xmark")
           }
       }
       
       // MARK: - Private
       
       private func sendMessage() {
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


struct  SegmentsView: View {
    let segments: [Transcript.Segment]
    let isUser: Bool
    
    var body: some View {
        VStack {
            ForEach(segments, id: \.id) { segment in
                switch segment {
                case .text(let text):
                    VStack{
                        Text(LocalizedStringKey(text.content))
                            .padding(8)
                            .background(isUser ? Color.blue.opacity(0.2) : nil)
                            .cornerRadius(8)
                            .contentTransition(.interpolate)
                            .animation(.easeInOut(duration: 0.3), value: text)
                    }
                    .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)
                case .structure:
                    EmptyView()
                @unknown default:
                    EmptyView()
                }
            }
        }
    }
}
