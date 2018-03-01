//
//  HostFileManager.swift
//  Local DNS Manager
//
//  Created by Johns Paul on 28/2/18.
//  Copyright © 2018 TechNut. All rights reserved.
//

import Cocoa

class HostFileManager: NSObject {
    let filePath = "/etc/hosts";
    let outputFile = "hosts"
    let outputDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    var outputFileURL: URL
    
    override init() {
        outputFileURL = outputDirectory!.appendingPathComponent(outputFile)
    }
    
    func getContents() -> String {
        let fileManager = FileManager.default
        var contents: String
        if(fileManager.fileExists(atPath: filePath)) {
            contents = try! String.init(contentsOfFile: filePath, encoding: .utf8)
            return contents
        }
        return ""
    }
    
    func updateIP(identifier: String, newIP: String) {
        var lines: [String] = []
        self.getContents().enumerateLines { line, _ in lines.append(line)}
        
        let newline = "\n"
        let home = FileManager.default.homeDirectoryForCurrentUser
        
        let demoFileURL = home.appendingPathComponent(outputFile)
        
        let fileManager = FileManager.default
        fileManager.createFile(atPath: outputFileURL.path, contents: nil, attributes: nil)
        
        let fileHandle = try? FileHandle(forWritingTo: outputFileURL)
        
        for line in lines {
    
            if(line.range(of: ".*\t.*", options: .regularExpression, range: nil, locale: nil) != nil) {
                let separatedLine = line.split(separator: "\t")
                if(separatedLine[1] == identifier) {
                    let _newString = newIP + "\t" + separatedLine[1]
                    fileHandle?.seekToEndOfFile();
                    fileHandle?.write(_newString.data(using: .utf8)!)
                    fileHandle?.write(newline.data(using: .utf8)!)
                }
                else {
                    fileHandle?.seekToEndOfFile();
                    fileHandle?.write(line.data(using: .utf8)!)
                    fileHandle?.write(newline.data(using: .utf8)!)
                }
            }
            else {
                fileHandle?.seekToEndOfFile();
                fileHandle?.write(line.data(using: .utf8)!)
                fileHandle?.write(newline.data(using: .utf8)!)
            }
        }
        executeMoveScript()
    }
    
    func addNewIP(name: String, ip: String) {
        var lines: [String] = []
        self.getContents().enumerateLines { line, _ in lines.append(line)}
        
        let newline = "\n"
        let home = FileManager.default.homeDirectoryForCurrentUser
        let demoFileURL = home.appendingPathComponent(outputFile)
        
        let fileManager = FileManager.default
        fileManager.createFile(atPath: outputFileURL.path, contents: nil, attributes: nil)
        
        let fileHandle = try? FileHandle(forWritingTo: outputFileURL)
        
        for line in lines {
            fileHandle?.seekToEndOfFile();
            fileHandle?.write(line.data(using: .utf8)!)
            fileHandle?.write(newline.data(using: .utf8)!)
        }
        let _newString = ip + "\t" + name
        fileHandle?.seekToEndOfFile();
        fileHandle?.write(_newString.data(using: .utf8)!)
        fileHandle?.write(newline.data(using: .utf8)!)
        executeMoveScript()
    }
    
    func deleteIP(ip: String) {
        var lines: [String] = []
        self.getContents().enumerateLines { line, _ in lines.append(line)}
        
        let newline = "\n"
        let home = FileManager.default.homeDirectoryForCurrentUser
        let demoFileURL = home.appendingPathComponent(outputFile)
        
        let fileManager = FileManager.default
        fileManager.createFile(atPath: outputFileURL.path, contents: nil, attributes: nil)
        
        let fileHandle = try? FileHandle(forWritingTo: outputFileURL)
        
        for line in lines {
            
            if(line.range(of: ".*\t.*", options: .regularExpression, range: nil, locale: nil) != nil) {
                let separatedLine = line.split(separator: "\t")
                if(separatedLine[1] != ip) {
                    fileHandle?.seekToEndOfFile();
                    fileHandle?.write(line.data(using: .utf8)!)
                    fileHandle?.write(newline.data(using: .utf8)!)
                }
            }
            else {
                fileHandle?.seekToEndOfFile();
                fileHandle?.write(line.data(using: .utf8)!)
                fileHandle?.write(newline.data(using: .utf8)!)
            }
        }
        executeMoveScript()
    }
    
    func executeMoveScript() {
        let myAppleScript = "do shell script \"mv " + outputFileURL.path + " /etc/\" with administrator privileges"
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: myAppleScript) {
            scriptObject.executeAndReturnError(&error)
        }
    }
}
