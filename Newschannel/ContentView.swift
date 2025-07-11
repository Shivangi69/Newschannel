//
//  ContentView.swift
//  Newschannel
//
//  Created by apple on 10/07/25.
//

import SwiftUI

struct ContentView: View {
    // Pass Core Data context for use in child views
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        LoginView()
            .environment(\.managedObjectContext, viewContext) // Pass context to LoginView
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}

