//
//  Settings.swift
//  AtlasPDA
//
//  Created by Matthew Dudzinski on 10/9/25.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        List{
            NavigationLink("Permissions") {
                RequestPermissions()
            }
        }
    }
}

#Preview {
    SettingsView()
}
