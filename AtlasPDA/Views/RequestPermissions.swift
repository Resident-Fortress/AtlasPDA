//
//  RequestPermissions.swift
//  AtlasPDA
//
//  Created by Matthew Dudzinski on 10/9/25.
//
import SwiftUI
import EventKit

struct RequestPermissions: View {
    @State private var accessGranted: Bool? = nil
    private let eventStore = EKEventStore()
    
    var body: some View {
        NavigationStack {
            List {
                Section("Calendar Permissions") {
                    if let granted = accessGranted {
                        if granted {
                            Label("Access Granted", systemImage: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else {
                            Label("Access Denied", systemImage: "xmark.octagon.fill")
                                .foregroundColor(.red)
                        }
                    } else {
                        Label("Not Requested", systemImage: "questionmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    
                    Button("Request Calendar Access") {
                        requestCalendarAccess()
                    }
                }
            }
            .navigationTitle("Permissions")
        }
        .onAppear {
            checkCurrentStatus()
        }
    }
    
    private func requestCalendarAccess() {
        Task {
            do {
                let granted = try await eventStore.requestAccess(to: .event)
                await MainActor.run {
                    accessGranted = granted
                }
            } catch {
                print("Failed to request calendar access: \(error)")
                await MainActor.run {
                    accessGranted = false
                }
            }
        }
    }
    
    private func checkCurrentStatus() {
        let status = EKEventStore.authorizationStatus(for: .event)
        switch status {
        case .authorized:
            accessGranted = true
        case .denied, .restricted:
            accessGranted = false
        case .notDetermined:
            accessGranted = nil
        @unknown default:
            accessGranted = nil
        }
    }
}

#Preview {
    RequestPermissions()
}
