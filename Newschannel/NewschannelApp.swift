//
//  NewschannelApp.swift
//  Newschannel
//
//  Created by apple on 10/07/25.
//

import SwiftUI

@main
struct NewschannelApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
