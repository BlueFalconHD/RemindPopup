//
//  RemindPopup.swift
//  RemindPopup
//
//  Created by Hayes Dombroski on 6/13/24.
//

import SwiftUI
import SwiftData

@main
struct MakeGoodChoicesApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.openWindow) var openWindow
    
    var body: some Scene {
        
        WindowGroup {
            DummyWindowContentView()
        }
        
        Window("Settings", id: "Settings") {
            SettingsContentView()
        }
        
        MenuBarExtra(content: {
            Button("Settings") {
                openWindow(id: "Settings")
            }
                .keyboardShortcut(",")
            
            Button("Open Popup") {
                appDelegate.createAndShowWindow()
            }
                .keyboardShortcut("p")
            
            Divider()
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
                .keyboardShortcut(KeyboardShortcut("q"))
            
        }, label: {
                    Image(systemName: "hourglass.tophalf.filled")
        })
    }
}
