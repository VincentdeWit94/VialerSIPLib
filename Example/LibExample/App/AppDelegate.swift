//
//  AppDelegate.swift
//  LibExample
//
//  Created by Manuel on 08/10/2019.
//  Copyright © 2019 Harold. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let app: RootApp
    
    override init() {
        
        let sipLib = VialerSIPLib.sharedInstance()
        let endPoint =  VSLEndpointConfiguration()
        let transport = VSLTransportConfiguration(transportType: .UDP)!
        endPoint.transportConfigurations.append(transport)
        endPoint.userAgent = "VialerSIPLib Example App"
        endPoint.unregisterAfterCall = true
        
    
       do {
           try sipLib.configureLibrary(withEndPointConfiguration: endPoint)

       } catch let error {
           print("Error setting up VialerSIPLib: \(error)")
       }
        app = RootApp(dependencies: Dependencies(callStarter: CallStarter(vialerSipLib: sipLib)))
        super.init()
        
        
    }
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationController = MessageNavigationController(rootViewController:  CallingViewController())
        let tabBarController = MessageTabBarController()
        
        tabBarController.setViewControllers([navigationController], animated: false)

        tabBarController.responseHandler = app
        app.add(subscriber: tabBarController)
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if let window = window {
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
        }
        
        return true
    }
}
