//
//  CalendarTool.swift
//  AtlasPDA
//
//  Created by Matthew Dudzinski on 10/9/25.
//

import FoundationModels
import EventKit

final class CalendarTool: Tool {

    // MARK: - Tool Metadata
    let name = "calendar"
    let description = "Create a calendar event with a title and date (ISO8601 or human-readable)."

    // MARK: - Tool Arguments
    @Generable
    struct Arguments: Codable {
        var title: String
        var date: String // ISO8601 preferred, human-readable allowed
    }

    private let store = EKEventStore()

    // MARK: - Tool Execution
    func call(arguments: Arguments) async throws -> GeneratedContent {

        // 1️⃣ Attempt ISO8601 first
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime] // includes Z for UTC
        var eventDate: Date? = isoFormatter.date(from: arguments.date)

        // 2️⃣ If ISO8601 fails, try a human-readable format
        if eventDate == nil {
            let humanFormatter = DateFormatter()
            humanFormatter.locale = Locale(identifier: "en_US_POSIX")
            humanFormatter.dateFormat = "MMMM d, yyyy 'at' h a" // e.g., September 10, 2025 at 3 PM
            eventDate = humanFormatter.date(from: arguments.date)
        }

        // 3️⃣ Fail if neither worked
        guard let finalDate = eventDate else {
            throw NSError(domain: "CalendarTool",
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Invalid date format. Use ISO8601 or 'MMMM d, yyyy at h a'."])
        }

        // 4️⃣ Request Calendar access
        let granted = try await store.requestAccess(to: .event)
        guard granted else {
            throw NSError(domain: "CalendarTool",
                          code: 2,
                          userInfo: [NSLocalizedDescriptionKey: "Calendar access denied"])
        }

        // 5️⃣ Create Event
        let event = EKEvent(eventStore: store)
        event.title = arguments.title
        event.startDate = finalDate
        event.endDate = finalDate.addingTimeInterval(3600)
        event.calendar = store.defaultCalendarForNewEvents

        try store.save(event, span: .thisEvent)

        return GeneratedContent(
            "📅 Event '\(arguments.title)' scheduled for \(finalDate.formatted())."
        )
    }
}
