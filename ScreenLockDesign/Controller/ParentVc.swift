//
//  ParentVc.swift
//  ScreenLockDesign
//
//  Created by surya-zstk231 on 22/06/21.
//

import UIKit

class ParentVc: UIViewController {

    
    let storyBoard = UIStoryboard(name: Constants.storyBoardID, bundle: nil)
    var unLock: Bool = false
    
    let alreadyHavePIN = UserDefaults.standard.string(forKey: Constants.PIN)
    @IBOutlet weak var topView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = false
        
    }
    
    func checkVc(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let window = delegate.window
        
        if alreadyHavePIN != nil {
            
            
            if UserDefaults.standard.bool(forKey: Constants.IsBioMtricLockActivated) {
                let presentVc = storyBoard.instantiateViewController(withIdentifier: Constants.BioMetricLockVcID) as! BioMetricLockVc
                
                presentVc.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
                presentVc.view.layer.zPosition = 1
                window?.rootViewController?.view.addSubview(presentVc.view)
                
                presentVc.isUnlock = { input in
                    presentVc.view.removeFromSuperview()
                }
                
                
            } else {
                let presentVc = storyBoard.instantiateViewController(withIdentifier: Constants.PINPageVcID) as! PINPageVc
                presentVc.PINState = .Check
                
                presentVc.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
                presentVc.view.layer.zPosition = 1
                window?.rootViewController?.view.addSubview(presentVc.view)
                
                presentVc.isUnlock = { input in
                    presentVc.view.removeFromSuperview()
                }
                
                
            }
            

        } else {
            UserDefaults.standard.set(false, forKey: Constants.PasswordExists)
            UserDefaults.standard.set(false, forKey: Constants.IsBioMtricLockActivated)
            UserDefaults.standard.set(0, forKey: Constants.UserGivenTimeDuration)
            let presentVc = storyBoard.instantiateViewController(withIdentifier: Constants.MainVcID) as! MainVc
            presentVc.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            
            presentVc.isPasswordAlreadySet = false
    
            presentVc.view.layer.zPosition = 1
            window?.rootViewController?.view.addSubview(presentVc.view)
            
        }
    }
    

}
