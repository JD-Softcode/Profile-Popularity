//
//  AppDelegate.swift
//  Profile Popularity
//
//  Created by Jeff on 12/30/18.
//  Copyright © 2018 J∆•Softcode. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!
	@IBOutlet weak var myTableView: NSTableView!
	@IBOutlet weak var resetButton: NSButton!
	@IBOutlet weak var doneButton: NSButton!
	@IBOutlet weak var profileDisplayData: ProfileTableData!
	
	let myPrioritizer = ProfileProgrammer()
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		myPrioritizer.setUp()
		
		//profileDisplayData.initializeTable(tableView: myTableView)
	}

	@IBAction func resetBtn(_ sender: NSButton) {
		profileDisplayData.resetNewRanks(tableView: myTableView)
	}
	
	@IBAction func doneBtn(_ sender: NSButton) {		//save and close
		if myPrioritizer.doSaveFile(theData: profileDisplayData) {
			window.close()
		}
	}
	
	@IBAction func openMenuItem(_ sender: NSMenuItem) {
		let theFile:URL = myPrioritizer.openFileDialog()
		if theFile.isFileURL {
			myPrioritizer.loadFileData(withFile: theFile, dataStore: profileDisplayData)
			myTableView.reloadData()
		}
	}
	
	@IBAction func saveMenuItem(_ sender: NSMenuItem) {
		_ = myPrioritizer.doSaveFile(theData: profileDisplayData)
	}
	
	func application(_ sender: NSApplication, openFile filename: String) -> Bool {
		// this is invoked with "Open Recent" menu item and probably dag-and-drop in Finder
		let theURL = URL(fileURLWithPath: filename)
		if theURL.isFileURL {
			myPrioritizer.loadFileData(withFile: theURL, dataStore: profileDisplayData)
			myTableView.reloadData()
		}
		return true		// false gives user feedback the file is not supported by the app
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
	
	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
		return true
	}


}

