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
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    //***********************************************************************
    
    //Action handlers for buttons
    
    //Opens the template designer
    @IBAction func templateDesignerClicked(_ sender: NSMenuItem) {
        print("Template Designer was clicked!")
    }

    //redirect to our website? Open new window? no idea really
    @IBAction func AboutClicked(_ sender: NSMenuItem) {
        print("About was clicked")
    }
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    //***********************************************************************
    
    //Selectors for menu items
    
    //When a template is clicked
    @objc func TemplateClicked(_ send: NSMenuItem?){
		
		fileSystem.loadLayout(send!.title)
		
		MenuTemplates.item(at: 0)?.state = NSControl.StateValue.off
		
        // Rearranges the positions of the menu items
        let index = MenuTemplates.index(of: send!)
        MenuTemplates.removeItem(at: index)
        MenuTemplates.insertItem(send!, at: 0)
		
		MenuTemplates.item(at: 0)?.state = NSControl.StateValue.on
    }
    
    // When the others option is clicked. Probably open up the Template Designer?
    @objc func OthersClicked(_ send: AnyObject?){
			print(" Others was clicked: \(String(describing: send))")
    }
    
    //***********************************************************************
    
    override func awakeFromNib() {
        let icon = NSImage(named: NSImage.Name(rawValue: "MenuIcons"))
        icon?.isTemplate = false // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        
        MenuTemplates.removeItem(at: 0)
        
        MenuTemplates.addItem(withTitle: "Standard", action: #selector(StatusMenuController.TemplateClicked(_:)), keyEquivalent: "")
        MenuTemplates.item(at: 0)?.target = self
        MenuTemplates.addItem(withTitle: "Horizontal", action: #selector(StatusMenuController.TemplateClicked(_:)), keyEquivalent: "")
        MenuTemplates.item(at: 1)?.target = self
        MenuTemplates.addItem(withTitle: "Others...", action: #selector(StatusMenuController.OthersClicked(_:)), keyEquivalent: "")
        MenuTemplates.item(at: 2)?.target = self
		
		MenuTemplates.item(at: 0)?.state = NSControl.StateValue.on
        
    }
    
    
}
