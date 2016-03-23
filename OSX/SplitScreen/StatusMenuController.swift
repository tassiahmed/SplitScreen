//
//  StatusMenuController.swift
//  SplitScreen
//
//  Created by Evan Thompson on 3/22/16.
//  Copyright © 2016 SplitScreen. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    
    @IBAction func templateDesignerClicked(sender: NSMenuItem) {
        print("Template Designer was clicked!")
    }

    //@IBOutlet weak var RecentTemplates: NSMenuItem!
    
    @IBAction func AboutClicked(sender: NSMenuItem) {
        print("About was clicked")
    }
    
    func TemplateClicked(send: NSMenuItem?){
        print(" template was clicked: \(send)")
    }
    
    func OthersClicked(send: AnyObject?){
        print(" Others was clicked: \(send)")
    }
    
    @IBOutlet weak var MenuTemplates: NSMenu!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
    override func awakeFromNib() {
        let icon = NSImage(named: "MenuIcons")
        icon?.template = false // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        
        MenuTemplates.removeItemAtIndex(0)
        
        MenuTemplates.addItemWithTitle("Template 1", action: Selector("TemplateClicked:"), keyEquivalent: "")
        MenuTemplates.itemAtIndex(0)?.target = self
        MenuTemplates.addItemWithTitle("Template 2", action: Selector("TemplateClicked:"), keyEquivalent: "")
        MenuTemplates.itemAtIndex(1)?.target = self
        MenuTemplates.addItemWithTitle("Template 3", action: Selector("TemplateClicked:"), keyEquivalent: "")
        MenuTemplates.itemAtIndex(2)?.target = self
        MenuTemplates.addItemWithTitle("Others...", action: Selector("OthersClicked:"), keyEquivalent: "")
        MenuTemplates.itemAtIndex(3)?.target = self
        
    }
    
    
}
