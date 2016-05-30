//
//  Language.swift
//  SyntaxKit
//
//  Created by Sam Soffes on 9/18/14.
//  Copyright © 2014-2015 Sam Soffes. All rights reserved.
//

import Foundation

public struct Language {

	// MARK: - Properties

	public let UUID: String
	public let name: String
	public let scopeName: String
	let patterns: [Pattern]


	// MARK: - Initializers

	public init?(dictionary: [NSObject: AnyObject]) {
		guard let UUID = dictionary["uuid"] as? String,
			name = dictionary["name"] as? String,
			scopeName = dictionary["scopeName"] as? String
			else { return nil }

		self.UUID = UUID
		self.name = name
		self.scopeName = scopeName

        var patterns = [Pattern]()
		var repository = [String: Pattern]()
		if let repo = dictionary["repository"] as? [String: [NSObject: AnyObject]] {
			for (key, value) in repo {
                // for patterns that contain repositories
                if let subPatterns = value["patterns"] as? [[String: String]],
                           subRepo = value["repository"] as? [String: [NSObject: AnyObject]] {
                    for pattern in subPatterns {
                        if let include = pattern["include"] {
                            let key = include.substringFromIndex(include.startIndex.successor())
                            guard let subKey = subRepo[key] else { continue }
                            if let subPat = Pattern(dictionary: subKey) {
                                patterns.append(subPat)
                            }
                        }
                    }
                // for patterns that are actually multiple patterns
                } else if value["name"] == nil {
                    if let subPatterns = value["patterns"] as? [[String: AnyObject]] {
                        for p in subPatterns {
                            if let pattern = Pattern(dictionary: p) {
                                patterns.append(pattern)
                            }
                        }
                    }
                // for the standard repository == 1 pattern
                } else if let pattern = Pattern(dictionary: value) {
					repository[key] = pattern
				}
			}
		}


		if let array = dictionary["patterns"] as? [[NSObject: AnyObject]] {
			for value in array {
				if let include = value["include"] as? String {
					let key = include.substringFromIndex(include.startIndex.successor())
					if let pattern = repository[key] {
						patterns.append(pattern)
						continue
					}
				} else if let pattern = Pattern(dictionary: value) {
                    if pattern.description == nil {
                        print("Whasssssup")
                    }
					patterns.append(pattern)
				}
			}
		}
		self.patterns = patterns
	}
}
