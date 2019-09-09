//
//  Utils.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-08.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import UIKit

extension UIViewController {
    #if DEBUG
    @objc func injected() {
        viewDidLoad()
    }
    #endif
}
