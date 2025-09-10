//
//  ChatModels.swift
//  AtlasPDA
//
//  Created by Matthew Dudzinski on 9/9/25.
//

import Foundation

struct SavedMessage: Identifiable, Codable {
    let id: UUID
    let role: String
    let content: String
}