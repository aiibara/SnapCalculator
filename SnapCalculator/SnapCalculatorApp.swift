//
//  SnapCalculatorApp.swift
//  SnapCalculator
//
//  Created by Widya Limarto on 07/02/23.
//

import SwiftUI

@main
struct SnapCalculatorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
