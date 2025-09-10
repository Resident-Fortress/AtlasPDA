//
//  SegmentsView.swift
//  AtlasPDA
//
//  Created by Matthew Dudzinski on 9/9/25.
//

import SwiftUI
import FoundationModels

struct SegmentsView: View {
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