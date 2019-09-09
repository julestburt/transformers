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
        if true {   //Current.token != nil {
            self.showTransformers()
        } else {
            self.showLogin()
        }
    }

    func showLogin() {
        
    }
    
    func showTransformers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let showTransformers = storyboard.instantiateViewController(withIdentifier: "ShowTransformers") as? ShowTransformersVC
            else { return }
            show(showTransformers)
    }
    
    func show(_ nextViewController:UIViewController) {
        
        // Slight delay to avoid a black flash
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

}

extension UIViewController {
    func setRootVC() {
        if let window = UIApplication.shared.delegate?.window, let w = window {
            w.rootViewController = self
            w.makeKeyAndVisible()
        }
    }

}
