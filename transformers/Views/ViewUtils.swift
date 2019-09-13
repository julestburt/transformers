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

extension UIViewController {
    func show(_ nextViewController:UIViewController) {
        
        // Slight delay to avoid a black flash, particularly on older iOS9 devices
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            if let window = UIApplication.shared.delegate?.window, let w = window {
                
                let captureShot = self.capture(self.view.frame.size)
                let coverUpFakeShot = UIImageView()
                coverUpFakeShot.image = captureShot
                coverUpFakeShot.frame = w.bounds
                
                let fakeViewShot = UIImageView()
                fakeViewShot.image = captureShot
                fakeViewShot.frame = w.bounds
                
                let fakeCover = FakeCoverVC.init(nibName: "FakeCover", bundle: nil)
                fakeCover.view.addSubview(fakeViewShot)
                
                nextViewController.setRootVC()
                w.addSubview(coverUpFakeShot)
                
                nextViewController.present(fakeCover, animated: false) {
                    coverUpFakeShot.removeFromSuperview()
                    // dismiss realFakeView to reveal nextViewController
                }
            }
        }
    }
    
    
        func capture(_ size:CGSize) -> UIImage? {
            UIGraphicsBeginImageContext(size)
            defer { UIGraphicsEndImageContext() }
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            view.layer.render(in: context)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
    
    func setRootVC() {
        if let window = UIApplication.shared.delegate?.window, let w = window {
            w.rootViewController = self
            w.makeKeyAndVisible()
        }
    }

    static func named(_ name:String, storyboard:String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: name)
    }

    #if DEBUG
    @objc func injected() {
        viewDidLoad()
    }
    #endif
    

}
