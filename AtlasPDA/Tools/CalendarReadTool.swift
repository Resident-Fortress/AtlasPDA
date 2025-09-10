//
//  CalendarReadTool.swift
//  AtlasPDA
//
//  Created by Matthew Dudzinski on 10/9/25.
//

import FoundationModels
import EventKit

final class CalendarReadTool: Tool {

    let name = "calendar_read"
    let description = "Read upcoming calendar events from the user's default calendar."

    @Generable
    struct Arguments: Codable {
        var daysAhead: Int // how many days into the future to read events
    }

    private let store = EKEventStore()

    func call(arguments: Arguments) async throws -> GeneratedContent {
        // Request access to Calendar
        let granted = try await store.requestAccess(to: .event)
        guard granted else {
            throw NSError(domain: "CalendarReadTool",
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Calendar access denied"])
        }

        // Calculate date range
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .day, value: arguments.daysAhead, to: startDate)!

        // Fetch events
        let predicate = store.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        let events = store.events(matching: predicate)

        // Format results
        let formatted = events.map { event in
            [
                "title": event.title ?? "No Title",
                "startDate": ISO8601DateFormatter().string(from: event.startDate),
                "endDate": ISO8601DateFormatter().string(from: event.endDate)
            ]
        }

        // Return as JSON string
        let data = try JSONSerialization.data(withJSONObject: formatted, options: [.prettyPrinted])
        let jsonString = String(data: data, encoding: .utf8) ?? "[]"

        return GeneratedContent(jsonString)
    }
}
