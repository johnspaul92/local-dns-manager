//
//  AddNewWindow.swift
//  Local DNS Manager
//
//  Created by Johns Paul on 28/2/18.
//  Copyright © 2018 TechNut. All rights reserved.
//

import Cocoa

class AddNewWindow: NSWindowController {

    @IBOutlet weak var ipField: NSTextField!
    @IBOutlet weak var hostNameField: NSTextField!
    
    var delegate: EditWindowDelegate?
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let controller = HostFileManager()
        controller.addNewIP(name: hostNameField.stringValue, ip: ipField.stringValue)
        delegate?.updateIP()
        self.window?.close()
    }
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(self)
        NSApp.activate(ignoringOtherApps: true)
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name("AddNewWindow")
    }
    
}
