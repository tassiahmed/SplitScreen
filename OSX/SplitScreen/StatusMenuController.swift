//
//  StatusMenuController.swift
//  SplitScreen
//
//
//
//  Created by Evan Thompson on 3/22/16.
//  Copyright © 2016 SplitScreen. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var MenuTemplates: NSMenu!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    
    //***********************************************************************
    
    //Action handlers for buttons
    
    //Opens the template designer
    @IBAction func templateDesignerClicked(sender: NSMenuItem) {
        print("Template Designer was clicked!")
    }

    //redirect to our website? Open new window? no idea really
    @IBAction func AboutClicked(sender: NSMenuItem) {
        print("About was clicked")
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    //***********************************************************************
    
    //Selectors for menu items
    
    //When a template is clicked
    func TemplateClicked(send: NSMenuItem?){
        print(" template was clicked: \(send)")
        
		file_system.loadLayout(send!.title)
		
		MenuTemplates.itemAtIndex(0)?.state = NSOffState
		
        //rearranges the positions of the menu items
        let index = MenuTemplates.indexOfItem(send!)
        MenuTemplates.removeItemAtIndex(index)
        MenuTemplates.insertItem(send!, atIndex: 0)
		
		MenuTemplates.itemAtIndex(0)?.state = NSOnState
    }
    
    //When the others option is clicked. Probably open up the Template Designer?
    func OthersClicked(send: AnyObject?){
        print(" Others was clicked: \(send)")
    }
    
    //***********************************************************************
    
    override func awakeFromNib() {
        let icon = NSImage(named: "MenuIcons")
        icon?.template = false // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        
        MenuTemplates.removeItemAtIndex(0)
        
        MenuTemplates.addItemWithTitle("Standard", action: #selector(StatusMenuController.TemplateClicked(_:)), keyEquivalent: "")
        MenuTemplates.itemAtIndex(0)?.target = self
        MenuTemplates.addItemWithTitle("Horizontal", action: #selector(StatusMenuController.TemplateClicked(_:)), keyEquivalent: "")
        MenuTemplates.itemAtIndex(1)?.target = self
        MenuTemplates.addItemWithTitle("Default", action: #selector(StatusMenuController.TemplateClicked(_:)), keyEquivalent: "")
        MenuTemplates.itemAtIndex(2)?.target = self
        MenuTemplates.addItemWithTitle("Others...", action: #selector(StatusMenuController.OthersClicked(_:)), keyEquivalent: "")
        MenuTemplates.itemAtIndex(3)?.target = self
		
		MenuTemplates.itemAtIndex(0)?.state = NSOnState
        
    }
    
    
}
