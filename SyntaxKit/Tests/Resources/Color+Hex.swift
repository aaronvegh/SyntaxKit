//
//  Color+Hex.swift
//  SyntaxKit
//
//  Created by Aaron Vegh on 2016-05-28.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

import CoreGraphics
import X

extension Color {
    
    static func hexStringFromColor(color: Color) -> NSString? {
        let components = CGColorGetComponents(color.CGColor)
        let r: Float = Float(components[0])
        let g: Float = Float(components[1])
        let b: Float = Float(components[2])

        return NSString.localizedStringWithFormat("#%02lX%02lX%02lX", lroundf(r * 255),
                                                                      lroundf(g * 255),
                                                                      lroundf(b * 255))
    }
}
