//
//  ProfileTableData.swift
//  Profile Popularity
//
//  Created by Jeff on 12/31/18.
//  Copyright © 2018 J∆•Softcode. All rights reserved.
//

import Cocoa

class ProfileTableData: NSObject, NSTableViewDelegate, NSTableViewDataSource {
	
	var profileData = [[String]]()
	var newRowIncrementer: Int = 0
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		return profileData.count
	}
	
	func addRow(oldRank: String, profileName: String) {
		profileData.append([" ",oldRank,profileName])
	}
	
	func resetNewRanks(tableView: NSTableView) {
		var i:Int = 0
		while i < profileData.count {		// doing "for i in [0...count-1]" failed because i is a "Range" & can't index an Array
			profileData[i][0] = " "
			i += 1
		}
		tableView.reloadData()
		newRowIncrementer = 0
	}
	
	func clearAll() {
		profileData = [[String]]()
		newRowIncrementer = 0
	}
	
	func doRowClicked(row: Int) {	// called by the system
		newRowIncrementer += 1
		profileData[row][0] = "\(newRowIncrementer)"
	}
	
	func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
		//asks if the current row is valid for selection; use this to detect a mouse down
		doRowClicked(row: row)
		tableView.reloadData(forRowIndexes: [row], columnIndexes: [0])
		return true
	}
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		//asks for a view to display at this row and column
		var result:NSTextField
		let existing = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MyView"), owner: self)
		if (existing != nil) {
			result = existing as! NSTextField
			//print("found")
		} else {
			result = NSTextField()			//frame: NSMakeRect(10, 0, (tableColumn?.width)!, tableView.rowHeight))
			result.identifier = NSUserInterfaceItemIdentifier(rawValue: "MyView")
			result.isBordered = false
			result.drawsBackground = false
			result.isEditable = false
			//print("created on row \(row)")
		}
		
		if profileData.count > 1 {
			if tableColumn!.title == tableView.tableColumns[0].title {
				result.stringValue = profileData[row][0]
				result.alignment = NSTextAlignment.center
			} else if tableColumn!.title == tableView.tableColumns[1].title {
				result.stringValue = profileData[row][1]
				result.alignment = NSTextAlignment.center
			} else {
				result.stringValue = profileData[row][2]
				result.alignment = NSTextAlignment.left
			}
		}
		
		return result
	}
	
}
