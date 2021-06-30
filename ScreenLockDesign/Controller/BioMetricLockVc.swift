//
//  FingerPrintCheckVc.swift
//  ScreenLockDesign
//
//  Created by surya-zstk231 on 16/06/21.
//

import UIKit
import LocalAuthentication

class BioMetricLockVc: UIViewController {
    var window: UIWindow?
    
    var isUnlock: ((_ isUpdated: Bool) -> Void)?
    var isErrorOccuired: ((_ isErrorOccuaired: Bool) ->Void)?

    let storyBoard = UIStoryboard(name: Constants.storyBoardID, bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()

        detectFace()
        
    }
    
    

    func detectFace(){
        let context = LAContext()
        var error: NSError? = nil
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Please authorised") {[self] success, error in
                DispatchQueue.main.async {
                    if error == nil {
                        if success {
                            isUnlock?(true)
                        
                        } else {
                            isUnlock?(false)
                        }
                    }else {
                        isErrorOccuired?(true)
                    }
                    
                }
                
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Cancel", style: .cancel) { action in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    

}
