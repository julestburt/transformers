//
//  ViewUtils.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-08.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import UIKit

func randomLightUIColor()->UIColor{
    return UIColor.randomLight()
}
extension UIColor {
    public static func randomLight() -> UIColor {
        let red:CGFloat = CGFloat((arc4random_uniform(127) + 128)) / 255.0
        let green:CGFloat = CGFloat((arc4random_uniform(127) + 128)) / 255.0
        let blue:CGFloat = CGFloat((arc4random_uniform(127) + 128)) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
