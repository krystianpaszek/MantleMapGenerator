//
//  main.swift
//  Mantle Map Generator
//
//  Created by Krystian Paszek on 14.04.2016.
//  Copyright © 2016 Krystian Paszek. All rights reserved.
//

import Foundation

extension String {
    var camelCasedString: String {
        let source = self
        if source.characters.contains(" ") {
            let first = source.substringToIndex(source.startIndex.advancedBy(1))
            let cammel = NSString(format: "%@", (source as NSString).capitalizedString.stringByReplacingOccurrencesOfString(" ", withString: "", options: [], range: nil)) as String
            let rest = String(cammel.characters.dropFirst())
            return "\(first)\(rest)"
        } else {
            let first = (source as NSString).lowercaseString.substringToIndex(source.startIndex.advancedBy(1))
            let rest = String(source.characters.dropFirst())
            return "\(first)\(rest)"
        }
    }
    
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercaseString + String(characters.dropFirst())
    }
    
    var lowercaseFirst: String {
        return first.lowercaseString + String(characters.dropFirst())
    }
    
    func replace(string:String, replacement:String) -> String {
        return self.stringByReplacingOccurrencesOfString(string, withString: replacement, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "").replace("\n", replacement: "")
    }
}

for argument in Process.arguments {
    let stdin = NSFileHandle.fileHandleWithStandardInput()
    let data = stdin.readDataToEndOfFile()
    if let fileAsString = String(data: data, encoding: NSUTF8StringEncoding) {
        var trimmed = fileAsString.removeWhitespace()
        var a = trimmed.substringToIndex(trimmed.endIndex.predecessor()).stringByReplacingOccurrencesOfString(" ", withString:"").componentsSeparatedByString(",")
        
        var b = a.map { (s : String) -> String in
            return s.componentsSeparatedByString(":").first!.stringByReplacingOccurrencesOfString("\"", withString: "")
        }
        
        var c = b.map { (s : String) -> String in
            let camelCase = s.stringByReplacingOccurrencesOfString("_", withString:" ").camelCasedString.lowercaseFirst
            return "@\"\(camelCase)\" : @\"\(s)\", "
        }
        
        var d = c.reduce("", combine:{$0+$1+"\n"})
        
        print(d)
    }
}

