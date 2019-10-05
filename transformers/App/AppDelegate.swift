//
//  AppDelegate.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-08.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import UIKit
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        checkUnitTestingSetup()
        debugUser()
//        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
        return true
    }    
}

fileprivate func debugUser() {
    #if DEBUG
    print("User token: \(User.token ?? "nil")")
//            let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0cmFuc2Zvcm1lcnNJZCI6Ii1Mb1RvVEVsZENqQm5aQTJycUowIiwiaWF0IjoxNTY4MTgwMTM0fQ.G0VrPMTpd5zQMlKVr1w3cHExXHgN0GIE01I62a5VSUs"
//            UserDefaults.standard.set(token, forKey: defaults.userToken)
    
//            User.clearStoredUser()
    #endif
}

fileprivate func checkUnitTestingSetup() {
    UserDefaults.standard.removeObject(forKey:UserDefaults.keys.isTesting)
    #if DEBUG
    if ProcessInfo.processInfo.arguments.contains("isTesting") {
        UserDefaults.standard.set(true, forKey:UserDefaults.keys.isTesting)
    }
    UserDefaults.standard.synchronize()
    #endif
}
