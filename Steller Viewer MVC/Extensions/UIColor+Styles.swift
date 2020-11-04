//
//  UIColor+Common.swift
//  Steller Viewer MVC
//
//  Created by plech on 03/11/2020.
//

import UIKit

extension UIColor {
    static let styleBlue = UIColor(hex: "#2980b9")
    static let styleDarkBlue = UIColor(hex: "#2c3e50")
}

extension UIColor {
    convenience init(hex: String) {
        guard hex.starts(with: "#"),
              hex.count == 7 else {
            print("Warning: Incorrect color definition: \(hex)")
            self.init(white: 1.0, alpha: 1.0)
            return
        }
        let redIndex = hex.index(hex.startIndex, offsetBy: 1)
        let greenIndex = hex.index(redIndex, offsetBy: 2)
        let blueIndex = hex.index(greenIndex, offsetBy: 2)
        let red = CGFloat(Int(hex[redIndex..<greenIndex], radix: 16) ?? 255) / 255
        let green = CGFloat(Int(hex[greenIndex..<blueIndex], radix: 16) ?? 255) / 255
        let blue = CGFloat(Int(hex[blueIndex...], radix: 16) ?? 255) / 255
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
