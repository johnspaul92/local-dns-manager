//
//  EditWindow.swift
//  Local DNS Manager
//
//  Created by Johns Paul on 28/2/18.
//  Copyright © 2018 TechNut. All rights reserved.
//

import Cocoa

class EditWindow: NSWindowController {
    
    var identifier = ""
    var delegate: EditWindowDelegate?
    
    func setId(id: String) {
        identifier = id
    }
    
    @IBOutlet weak var ipField: NSTextField!
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(self)
        NSApp.activate(ignoringOtherApps: true)
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name("EditWindow")
    }
    
    @IBAction func updateButtonClicked(_ sender: Any) {
        let controller = HostFileManager()
        controller.updateIP(identifier: identifier, newIP: ipField.stringValue)
        delegate?.updateIP()
        self.window?.close();
    }
    
}

protocol EditWindowDelegate {
    func updateIP()
}
