//
//  AppDelegate.swift
//  ToDoApp
//
//  Created by Alperen Ünal on 20.10.2018.
//  Copyright © 2018 Alperen Ünal. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
        
        do{
         try Realm()
        }
        catch{
            print("Error: \(error)")
        }
        
        return true
    }

    
    
}



