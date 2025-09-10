//
//  ChatInputView.swift
//  AtlasPDA
//
//  Created by Matthew Dudzinski on 9/9/25.
//

import SwiftUI

struct ChatInputView: View {
    @Binding var inputText: String
    let isResponding: Bool
    let onSend: () -> Void
    
    var body: some View {
        HStack {
            TextField("Type a message...", text: $inputText, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .disabled(isResponding)
            Button("Send") {
                onSend()
            }
            .disabled(inputText.isEmpty || isResponding)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}