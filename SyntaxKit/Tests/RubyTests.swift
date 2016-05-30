//
//  RubyTest.swift
//  SyntaxKit
//
//  Created by Aaron Vegh on 2016-05-26.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

import XCTest
@testable import SyntaxKit
import X

class RubyTests: XCTestCase {

    // MARK: - Properties

    func testRubyParsing() {

        let input = fixture("Swift", "txt")

        let swift = language("Swift")

        for pattern in swift.patterns {
            print(pattern.description)
        }

        let tomorrow = theme("Tomorrow")

        let attributedParser = AttributedParser(language: swift!, theme: tomorrow!)

        var changes = [[String: AnyObject]]()
        attributedParser.parse(input) { (scope: String, range: NSRange, attributes: Attributes?) in
            if let attr = attributes {
                changes.append(["scope": scope, "range": range, "attributes": attr])
            }
        }

        let outputString = NSMutableString(string: input)
        for change in changes.reverse() {
            guard let attrs = change["attributes"] as? [String: AnyObject],
                      color = attrs["NSColor"] as? Color,
                      range = change["range"] as? NSRange else { return }
            guard let hexString = Color.hexStringFromColor(color) else { return }
            let openTag = "<span style=\"color:" + String(hexString) + "\">"
            let closeTag = "</span>"
            outputString.insertString(closeTag, atIndex: range.location + range.length)
            outputString.insertString(openTag, atIndex: range.location)
        }

        let immutableString = "<html><body style=\"background-color:#000\"><div style='color:#fff'>" + String(outputString) + "</div></body></html>"
        let finalString = NSMutableString(string: immutableString)

        finalString.replaceOccurrencesOfString("\n", withString: "<br/>", options: NSStringCompareOptions(rawValue: 0), range: NSRange(location: 0, length: outputString.length))

        print(finalString)
    }
}