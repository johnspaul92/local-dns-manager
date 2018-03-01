//
//  AppDelegate.swift
//  Local DNS Manager
//
//  Created by Johns Paul on 28/2/18.
//  Copyright © 2018 TechNut. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, EditWindowDelegate {
    
    @IBOutlet weak var dnsMenu: NSMenu!
    
    let dnsMenuItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var editWindow: EditWindow = EditWindow()
    var addNewWindow: AddNewWindow = AddNewWindow()
    
    @IBAction func quitMenuClicked(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let icon = NSImage(named: NSImage.Name(rawValue: "serverIcon1"));
        icon!.isTemplate = true // best for dark mode
        dnsMenuItem.image = icon
        dnsMenuItem.menu = dnsMenu
        setupMenu()
    }
    
    func setupMenu() {
        let quitMenuItem = NSMenuItem();
        quitMenuItem.title = "Quit"
        quitMenuItem.isEnabled = true;
        quitMenuItem.target = self;
        quitMenuItem.action = #selector(self.quitMenuClicked(sender:))
        
        let controller = HostFileManager()
        var lines: [String] = []
        controller.getContents().enumerateLines { line, _ in lines.append(line)}
        
        for line in lines {
            
            if(line.range(of: ".*\t.*", options: .regularExpression, range: nil, locale: nil) != nil) {
                let separatedLine = line.split(separator: "\t")
                
                if(separatedLine[1] != "localhost" && separatedLine[1] != "broadcasthost") {
                    //adding new menu item
                    let newMenuItem = NSMenuItem()
                    newMenuItem.isEnabled = true
                    newMenuItem.title = String(separatedLine[1])
                    newMenuItem.target = self;
                    
                    let subMenu = NSMenu()
                    let ipMenuItem = NSMenuItem()
                    ipMenuItem.title = String(separatedLine[0])
                    ipMenuItem.isEnabled = true;
                    ipMenuItem.target = self;
                    subMenu.addItem(ipMenuItem)
                    
                    let editMenuItem = NSMenuItem()
                    editMenuItem.title = "Edit"
                    editMenuItem.isEnabled = true
                    editMenuItem.target = self;
                    editMenuItem.action = #selector(self.editMenuClicked(sender:))
                    editMenuItem.identifier = NSUserInterfaceItemIdentifier(String(separatedLine[1]))
                    subMenu.addItem(editMenuItem)
                    
                    let deleteMenuItem = NSMenuItem();
                    deleteMenuItem.title = "Delete"
                    deleteMenuItem.isEnabled = true;
                    deleteMenuItem.target = self;
                    deleteMenuItem.identifier = NSUserInterfaceItemIdentifier(String(separatedLine[1]))
                    deleteMenuItem.action = #selector(self.deleteMenuClicked(sender:))
                    subMenu.addItem(deleteMenuItem)
                    
                    newMenuItem.submenu = subMenu
                    dnsMenu.addItem(newMenuItem)
                }
            }
        }
        
        let menuSeparator = NSMenuItem.separator()
        
        dnsMenu.addItem(menuSeparator)
        
        let newEntryMenuItem = NSMenuItem();
        newEntryMenuItem.title = "Add New Host"
        newEntryMenuItem.isEnabled = true;
        newEntryMenuItem.target = self;
        newEntryMenuItem.action = #selector(self.newEntryMenuClicked(sender:))
        
        dnsMenu.addItem(newEntryMenuItem)
        dnsMenu.addItem(quitMenuItem)
    }
    
    @objc
    func editMenuClicked(sender : NSMenuItem) {
        editWindow = EditWindow()
        editWindow.setId(id: sender.identifier!.rawValue)
        editWindow.delegate = self
        editWindow.showWindow(self)
    }
    
    @objc
    func quitMenuClicked(sender : NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    @objc
    func deleteMenuClicked(sender : NSMenuItem) {
        //NSApplication.shared.terminate(self)
        let controller = HostFileManager()
        controller.deleteIP(ip: sender.identifier!.rawValue)
        updateIP()
    }
    
    @objc
    func newEntryMenuClicked(sender : NSMenuItem) {
        addNewWindow = AddNewWindow()
        addNewWindow.delegate = self
        addNewWindow.showWindow(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func updateIP() {
        dnsMenu.removeAllItems();
        setupMenu();
    }
}

