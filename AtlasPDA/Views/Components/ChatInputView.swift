//
//  ChatInputView.swift
//  AtlasPDA
//
//  Created by Matthew Dudzinski on 9/9/25.
//

import SwiftUI

struct ChatInputView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var inputText: String
    @FocusState private var isFocused: Bool
    let isResponding: Bool
    let onSend: () -> Void

    var body: some View {
        HStack {
            TextField("Type a message...", text: $inputText, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .disabled(isResponding)
                .focused($isFocused)
            Button("Send") {
                onSend()
                isFocused = false
            }
            .disabled(inputText.isEmpty || isResponding)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}
