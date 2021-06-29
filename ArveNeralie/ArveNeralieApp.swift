//
//  ArveNeralieApp.swift
//  ArveNeralie
//
//  Created by teo on 29/06/2021.
//

import SwiftUI

@main
struct ArveNeralieApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {

        Settings {
            EmptyView()
        }
    }
    
    @MainActor
    class AppDelegate: NSObject, NSApplicationDelegate {

        var updateTimer: Timer?
        var updateInterval = 3.0
        
        var statusBarItem: NSStatusItem?
        
        private let pasteboard = NSPasteboard.general
        private var urlStrings = [String]()
        
        func applicationDidFinishLaunching(_ notification: Notification) {
            
            statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
            statusBarItem?.button?.title = "@Arvelie"
            
            if updateTimer == nil {
                updateTimer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { timer in
                    self.updateStatus()
                    self.updateInterval = 30
                }
            }
        }
                
        func neralieTime() -> Double {
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            formatter.timeZone = TimeZone(abbreviation: "UTC+1")
            
            let date = Date()
            let dateString = formatter.string(from: date)
            guard let nowTime = formatter.date(from: dateString) else { return 0 }
            
            let cal = Calendar.current
            return Double((cal.component(.minute, from: nowTime) * 60 + cal.component(.hour, from: nowTime) * 3600)) / 86.4
        }
        
        func updateStatus() {
            statusBarItem?.button?.title = String(format: "@%.0f", neralieTime())
        }
    }
}

extension Date {
    func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
         let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
         return addingTimeInterval(delta)
    }
}
