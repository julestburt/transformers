//
//  FakeSplashVC.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-08.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import UIKit

class FakeSplashVC: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        let startView = Current.user != nil ?
            showTransformers()
            :
            showLogin()
        self.show(startView)
    }

    func showLogin() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "Login")
    }
    
    func showTransformers() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ShowTransformers")
    }
    
//    func show(_ nextViewController:UIViewController) {
//
//        // Slight delay to avoid a black flash, particularly on older iOS9 devices
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
//            if let window = UIApplication.shared.delegate?.window, let w = window {
//
//                let captureShot = self.capture(self.view.frame.size)
//                let coverUpFakeShot = UIImageView()
//                coverUpFakeShot.image = captureShot
//                coverUpFakeShot.frame = w.bounds
//
//                let fakeViewShot = UIImageView()
//                fakeViewShot.image = captureShot
//                fakeViewShot.frame = w.bounds
//
//                let fakeCover = FakeCoverVC.init(nibName: "FakeCover", bundle: nil)
//                fakeCover.view.addSubview(fakeViewShot)
//
//                nextViewController.setRootVC()
//                w.addSubview(coverUpFakeShot)
//
//                nextViewController.present(fakeCover, animated: false) {
//                    coverUpFakeShot.removeFromSuperview()
//                    // dismiss realFakeView to reveal nextViewController
//                }
//            }
//        }
//    }
    
    
//    func capture(_ size:CGSize) -> UIImage? {
//        UIGraphicsBeginImageContext(size)
//        defer { UIGraphicsEndImageContext() }
//        guard let context = UIGraphicsGetCurrentContext() else { return nil }
//        view.layer.render(in: context)
//        return UIGraphicsGetImageFromCurrentImageContext()
//    }

}

class LoginNavigationController :UINavigationController {
//    var viewToPresent:(()->UIViewController)? = nil
    
    override func viewDidLoad() {
        //
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        if let view = viewToPresent?() {
//            present(view, animated: false) {
//                print("added view modally to stack")
//            }
//        }
//    }
}
