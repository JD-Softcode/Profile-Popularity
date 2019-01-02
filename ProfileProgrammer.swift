//
//  ProfileProgrammer.swift
//  Profile Popularity
//
//  Created by Jeff on 12/31/18.
//  Copyright © 2018 J∆•Softcode. All rights reserved.
//

import Cocoa

class ProfileProgrammer: NSObject {
	
	var originalFileLines = [String]()
	var openedFileURL = URL.init(string: "")
	let variantLineID = "variant"

	func setUp() {
		//print("programmer is set up!")
	}
	
	func openFileDialog() -> URL {
		let myOpenPanel = NSOpenPanel()
		myOpenPanel.canChooseFiles = true
		myOpenPanel.canChooseDirectories = false
		myOpenPanel.allowsMultipleSelection = false
		myOpenPanel.allowedFileTypes = ["txt"]
		myOpenPanel.runModal()
		NSDocumentController.shared.noteNewRecentDocumentURL(myOpenPanel.urls[0])
		return myOpenPanel.urls[0]
	}
	
	func loadFileData(withFile: URL, dataStore: ProfileTableData) {
		do {
			let allTheText = try String(contentsOf: withFile)
			dataStore.clearAll()
			originalFileLines = allTheText.components(separatedBy: NSCharacterSet.newlines)
			for line in originalFileLines {
				if !line.starts(with: variantLineID) {
					let lineParts:[String] = line.components(separatedBy: ";")
					if lineParts.count >= 9 {
						let profileName = "\(lineParts[5].trimmingCharacters(in: .whitespaces).dropLast(8)) (\(lineParts[0].trimmingCharacters(in: .whitespaces)))"
						let profileRank = lineParts[8].trimmingCharacters(in: .whitespaces)
						dataStore.addRow(oldRank: profileRank, profileName: profileName)
					}
				}
			}
			openedFileURL = withFile		// save for later use with Save
		}
		catch  {
			showDetailedWarning(note: "Could not open file URL.", detail: "\(error)")
		}
	}
	
	func allNewPriortiesSet(theData: ProfileTableData) -> Bool {
		var allSet = true
		var i:Int = 0
		while i < theData.profileData.count {	// doing "for i in [0...count-1]" failed because i is a "Range" & can't index an Array
			if theData.profileData[i][0] == " " {
				allSet = false
			}
			i += 1
		}
		return allSet
	}
	
	func doSaveFile(theData: ProfileTableData) -> Bool {
		var allIsWell = false
		var newFileContent = ""
		
		if (openedFileURL != nil) && (openedFileURL?.isFileURL)! {
			if allNewPriortiesSet(theData: theData) {
				var i:Int = 0
				var j:Int = 0
				var gotAnError = false
				while i < originalFileLines.count {
					if originalFileLines[i].starts(with: variantLineID) {
						newFileContent.append("\(originalFileLines[i])\n")
					} else {
						let lineParts:[String] = originalFileLines[i].components(separatedBy: ";")
						if lineParts.count == 9 {
							var newLine = "\(lineParts[0]);"
							var k:Int = 1
							while k <= 7 {
								newLine += "\(lineParts[k]);"
								k += 1
							}
							newLine += "\t\(theData.profileData[j][0])"
							j += 1
							newFileContent.append("\(newLine)")
							if i < (originalFileLines.count-1) {
								newFileContent.append("\n")
							}
						} else {
							showWarning(note: "Incorrect number of fields in line \(lineParts[0]).")
							gotAnError = true
						}
					}
					i += 1
				}
				if !gotAnError {
					do {
						try newFileContent.write(to: openedFileURL!, atomically: false, encoding: .ascii)
						allIsWell = true
						NSSound.init(named: "Glass")!.play()
					}
					catch {
						showDetailedWarning(note: "Could not save file URL.", detail: "\(error)")
					}
				}
			} else {
				showWarning(note: "Missing some new priorities.")
			}
		} else {
			showWarning(note: "No file open.")
		}
		return allIsWell
	}
	
	func showWarning(note: String) {
		showDetailedWarning(note: note, detail: "")
	}
	
	func showDetailedWarning(note: String, detail: String) {
		let myAlert = NSAlert()
		myAlert.messageText = note
		if detail == "" {
			myAlert.alertStyle = .warning
		} else {
			myAlert.informativeText = detail
			myAlert.alertStyle = .critical
		}
		myAlert.runModal()
	}
}
