//
//  FakeCoverVC.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-09.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import UIKit

//------------------------------------------------------------------------------
// MARK: Presented modally, revealing initial app destination screen
//------------------------------------------------------------------------------
class FakeCoverVC : UIViewController {
    override func viewDidLoad() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.dismiss(animated: true) {}
        }
    }
}
