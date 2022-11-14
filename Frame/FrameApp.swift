//
//  FrameApp.swift
//  Frame
//
//  Created by Max Berghaus on 14.11.22.
//

import SwiftUI

@main
struct FrameApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
