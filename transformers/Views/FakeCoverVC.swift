//
//  FakeCoverVC.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-09.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import UIKit

class FakeCoverVC : UIViewController {
    override func viewDidLoad() {
        print("On fake cover")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.dismiss(animated: true) {
                //
            }
        }
    }
}
