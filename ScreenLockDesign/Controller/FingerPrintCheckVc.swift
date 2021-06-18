//
//  FingerPrintCheckVc.swift
//  ScreenLockDesign
//
//  Created by surya-zstk231 on 16/06/21.
//

import UIKit
import LocalAuthentication

class FingerPrintCheckVc: UIViewController {

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
                    if success {
                        let alert = UIAlertController(title: "Success", message: "", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Go To Change PIN", style: .cancel, handler: nil)

                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)

                        self.navigationController?.dismiss(animated: true, completion: nil)
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.performSegue(withIdentifier: Constants.goToPINPage, sender: self)
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
