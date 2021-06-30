//
//  AppDelegate.swift
//  ScreenLockDesign
//
//  Created by surya-zstk231 on 16/06/21.
//

import UIKit
import CoreData
import LocalAuthentication

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    let storyBoard = UIStoryboard(name: Constants.storyBoardID, bundle: nil)
    
//    var presentVc: UIViewController?

    
    
    var screenLockActivatedVc: UIViewController?
//    var parentVc: UIViewController?
    
    
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let authType = LocalAuthManager.shared.biometricType
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "ParentVc")
        window?.rootViewController = vc
        
        window?.makeKeyAndVisible()
        
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let window = delegate.window
        let alreadyHavePIN = UserDefaults.standard.string(forKey: Constants.PIN)
        
        if alreadyHavePIN != nil {
            if UserDefaults.standard.bool(forKey: Constants.PasswordExists) {
            
            if UserDefaults.standard.bool(forKey: Constants.IsBioMtricLockActivated) {
                
                switch authType {
                        case .none:
                            forGoesToPINPage()
                        case .touchID:
                            isHaveBiometricLock()
                        case .faceID:
                            isHaveBiometricLock()
                        }
                
            
                
                
            } else {
                forGoesToPINPage()
            }
            }
            

        } else {
            UserDefaults.standard.set(false, forKey: Constants.PasswordExists)
            UserDefaults.standard.set(false, forKey: Constants.IsBioMtricLockActivated)
            UserDefaults.standard.set(0, forKey: Constants.UserGivenTimeDuration)
            let presentVc = storyBoard.instantiateViewController(withIdentifier: Constants.ParentVcID) as! ParentVc
            presentVc.view.bounds = window?.bounds ?? .zero
            
            
            self.window!.rootViewController = presentVc
            self.window?.makeKeyAndVisible()
            
        }
        
        return true
    }
    
    func isHaveBiometricLock(){
        let presentVc = storyBoard.instantiateViewController(withIdentifier: Constants.BioMetricLockVcID) as! BioMetricLockVc
        
        presentVc.view.bounds = window?.bounds ?? .zero
        presentVc.view.layer.zPosition = 1
        window?.rootViewController?.view.addSubview(presentVc.view)
        screenLockActivatedVc = presentVc
        
        presentVc.isUnlock = {[self] input in
            if input {
                presentVc.view.removeFromSuperview()
            } else {
                forGoesToPINPage()
                presentVc.view.removeFromSuperview()
            }
        }
        
        presentVc.isErrorOccuired = { [self] input in
            forGoesToPINPage()
            presentVc.view.removeFromSuperview()
            screenLockActivatedVc!.view.removeFromSuperview()
            
        }
    }
    
    func forGoesToPINPage(){
        let presentVc = storyBoard.instantiateViewController(withIdentifier: Constants.PINPageVcID) as! PINPageVc
        presentVc.PINState = .Check
        
        presentVc.view.bounds = window?.bounds ?? .zero
        presentVc.view.layer.zPosition = 1
        window?.rootViewController?.view.addSubview(presentVc.view)
        screenLockActivatedVc = presentVc
        
        presentVc.isUnlock = { input in
            presentVc.view.removeFromSuperview()
        }
    }
    var entersTime:CLongLong = 0
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if (screenLockActivatedVc != nil) {
            screenLockActivatedVc!.view.removeFromSuperview()
        }
        let firstTime = updateTime(currentTime: Date())
        UserDefaults.standard.set(firstTime, forKey: Constants.WhenAppGoesToBackground)
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        let pin = UserDefaults.standard.string(forKey: Constants.PIN)
        if pin != nil {
            entersTime = updateTime(currentTime: Date())
            let passwordExists = UserDefaults.standard.bool(forKey: Constants.PasswordExists)
            if passwordExists {
                let toAllow = checkUserComesAllowedLimitedTime(enterTime: Date())
                toSelectRootVc(toAllowMainPage: toAllow)
            }
        }
    }
    
    
    func updateTime(currentTime: Date) -> CLongLong{
        let timeInterval: TimeInterval = currentTime.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return millisecond
    }
    
    
    
    func checkUserComesAllowedLimitedTime(enterTime: Date) -> Bool{
        let goToBackgroundTime:CLongLong = UserDefaults.standard.object(forKey: Constants.WhenAppGoesToBackground) as! CLongLong
        let timings = UserDefaults.standard.object(forKey: Constants.UserGivenTimeDuration)
        let difference = entersTime - goToBackgroundTime
        if difference >= timings as! Int64 {
            return false
        }
        
        return true
    }
    
    func toSelectRootVc(toAllowMainPage: Bool){
        
        if toAllowMainPage {
            let presentVc = storyBoard.instantiateViewController(withIdentifier: Constants.MainVcID) as! MainVc
            presentVc.isPasswordAlreadySet = true
            presentVc.view.frame = window?.bounds ?? .zero
            presentVc.view.layer.zPosition = 1
            window?.rootViewController?.view.addSubview(presentVc.view)
        } else {
            if UserDefaults.standard.bool(forKey: Constants.IsBioMtricLockActivated) {
                
                let authType = LocalAuthManager.shared.biometricType
                
                switch authType {
                        case .none:
                            forGoesToPINPage()
                        case .touchID:
                            isHaveBiometricLock()
                        case .faceID:
                            isHaveBiometricLock()
                        }
                
            } else {
                forGoesToPINPage()
            }
            
        }
        
        
    }
    

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ScreenLockDesign")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


extension LAContext {
    enum BiometricType: String {
        case none
        case touchID
        case faceID
    }

    var biometricType: BiometricType {
        var error: NSError?

        guard self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }

        if #available(iOS 11.0, *) {
            switch self.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            @unknown default:
                #warning("Handle new Biometric type")
            }
        }
        
        return  self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
    }
}



