//
//  ContentView.swift
//  AtlasPDA
//
//  Created by Matthew Dudzinski on 9/9/25.
//

import SwiftUI
import FoundationModels

struct ContentView: View {
    @StateObject private var viewModel = ChatViewModel()
    
    var body: some View {
        VStack{
            if viewModel.isSystemAvailable {
                ChatView(viewModel: viewModel)
            } else {
                ContentUnavailableView(
                    viewModel.unavailabilityReason,
                    systemImage: "apple.intelligence.badge.xmark"
                )
            }
            
        }
        .toolbar {
            NavigationLink {
                SettingsView()
            } label: {
                Image(systemName: "gear")
            }
            
        }
    }
}

struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    
    var body: some View {
        List(viewModel.session.transcript) { entry in
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
            ChatInputView(
                inputText: $viewModel.inputText,
                isResponding: viewModel.session.isResponding,
                onSend: viewModel.sendMessage
            )
        }
        .onAppear {
            viewModel.prewarmSession()
        }
    }
}

#Preview {
    ContentView()
}
