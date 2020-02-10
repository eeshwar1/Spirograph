//
//  AppDelegate.swift
//  Spirograph
//
//  Created by Venky Venkatakrishnan on 12/25/19.
//  Copyright © 2019 Venky UL. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    @IBAction func exportAsImage(_ sender: NSMenuItem) {
        
        print("AppDelegate: Export menu clicked")
    }
}
