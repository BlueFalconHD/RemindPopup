//
//  AppDelegate.swift
//  RemindPopup
//
//  Created by Hayes Dombroski on 6/15/24.
//

import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?
    
    var appSettings: AppSettings = AppSettings()

    // MARK: - Application Lifecycle

    /// Called when the application has finished launching.
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Listen for system wake events
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(systemDidWake(_:)),
            name: NSWorkspace.didWakeNotification,
            object: nil
        )
    }
    
    /// Called when the application is about to terminate.
    func applicationWillTerminate(_ notification: Notification) {
        runCloseAnimation()
    }

    // MARK: - System Wake Handler

    /// Handles the system wake event.
    @objc func systemDidWake(_ notification: Notification) {
        // If the application is disabled, do not show the popup
        // Also, if the cooldown is enabled and the cooldown time has not passed, do not show the popup
        // cooldownPassed = (current time - last show time) > cooldown time
        let cooldownPassed = (Date().timeIntervalSince1970 - appSettings.popupLastShow) > appSettings.popupCooldownTime
    
        
        if !appSettings.applicationEnabled || (appSettings.enableCooldown && !cooldownPassed) {
            print("INFO :: Application is disabled or cooldown is active.")
            return
        }
        
        createAndShowWindow()
    }

    // MARK: - Popup Window Management

    /// Creates and shows the popup window.
    public func createAndShowWindow() {
        guard window == nil else {
            print("INFO :: Window is already created.")
            window?.makeKeyAndOrderFront(nil)
            return
        }
        
        // Set the popup last show date user default to the current time
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: AppSettingKey.popupLastShow.rawValue)

        let mainDisplayRect = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 800, height: 600)
        window = NSWindow(contentRect: mainDisplayRect, styleMask: [.borderless], backing: .buffered, defer: false)
        window?.isOpaque = false
        window?.backgroundColor = .clear

        let effectView = NSVisualEffectView(frame: mainDisplayRect)
        effectView.blendingMode = .behindWindow
        effectView.state = .active
        effectView.material = .hudWindow

        if let window = window {
            window.contentView = effectView

            let currentDate: Date = Date()

            print(
                "INFO :: { Sustain time: \(appSettings.popupSustainTime) }  { Fade in time: \(appSettings.popupFadeInTime) }  { Fade out time: \(appSettings.popupFadeOutTime) }"
            )

            let viewModel = PopupContentViewModel(
                openTime: currentDate,
                duration: appSettings.popupSustainTime + appSettings.popupFadeInTime,
                onTimeout: {
                    self.runCloseAnimation()
                }
            )

            let contentView = PopupContentView(viewModel: viewModel)
            let hostingView = NSHostingView(rootView: contentView)

            hostingView.frame = mainDisplayRect
            effectView.addSubview(hostingView)

            window.alphaValue = 0
            window.makeKeyAndOrderFront(nil)
            applyPopupProperties(to: window)

            NSAnimationContext.runAnimationGroup { context in
                context.duration = appSettings.popupFadeInTime
                window.animator().alphaValue = 1
            }

            viewModel.startTimer()
        }
    }
    
    /// Applies properties to the popup window.
    private func applyPopupProperties(to window: NSWindow) {
        window.level = .screenSaver
        guard let screen = NSScreen.main else {
            print("ERROR :: NSScreen.main is nil, no display is attached. Exiting")
            exit(1)
        }
        window.setFrame(screen.frame, display: true)
    }
    
    /// Runs the close animation for the popup window.
    private func runCloseAnimation() {
        guard let window = window else { return }

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = appSettings.popupFadeOutTime
            window.animator().alphaValue = 0
        }) {
            window.orderOut(nil)
            self.window = nil  // Ensure the window is properly deallocated
        }
    }
}
