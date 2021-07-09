//
//  UpdatedPINVc.swift
//  ScreenLockDesign
//
//  Created by surya-zstk231 on 20/06/21.
//

import UIKit
enum PINVerifyState {
    case Check
    case Update
}

class PINPageVc: UIViewController {
    
    @IBOutlet weak var fillViewOne: UIView!
    @IBOutlet weak var fillViewTwo: UIView!
    @IBOutlet weak var fillViewThree: UIView!
    @IBOutlet weak var fillViewFour: UIView!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    @IBOutlet weak var btn0: UIButton!
    @IBOutlet weak var dltBtn: UIButton!
    
    var isUnlock: ((_ isUpdated: Bool) -> Void)?

    var countOfTappedPIN:Int = 0
    
    var PINState:PINVerifyState = .Update
    
    var password:[String] = []
    
    var confirmPassword:[String] = []
    
    var attemptOfPINChageOperation = 1
    
    var window: UIWindow?
    let storyBoard = UIStoryboard(name: Constants.storyBoardID, bundle: nil)
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialAlignments()
    }
    
    
    func initialAlignments(){
        DispatchQueue.main.async { [self] in
            let viewArr:[UIView] = [fillViewOne,fillViewTwo,fillViewThree,fillViewFour]
            
            for i in 0...viewArr.count-1{
                viewArr[i].layer.borderColor = UIColor.systemGreen.cgColor
                viewArr[i].backgroundColor = UIColor(cgColor: UIColor.white.cgColor)
                viewArr[i].layer.borderWidth = 2
                viewArr[i].layer.cornerRadius = fillViewFour.frame.height/2
            }
            toCircleBtns()
        }
        
    }
    
    func toCircleBtns(){
        DispatchQueue.main.async { [self] in
            let btnArr:[UIButton] = [btn1,btn2,btn3,btn4,btn5,btn6,btn7,btn8,btn9,btn0,dltBtn]
            
            for i in 0...btnArr.count-1 {
                
                btnArr[i].layer.cornerRadius = btn1.frame.height/2
                btnArr[i].clipsToBounds = true
                btnArr[i].addTarget(self, action: #selector(self.numericBtnsTapped), for: .touchUpInside)
            }
        }
        
        
    }
    
    func dissmisView(){
        let presentVc = storyBoard.instantiateViewController(withIdentifier: Constants.MainVcID)
//        UIApplication.shared.windows.first?.rootViewController = presentVc
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
        self.navigationController?.pushViewController(presentVc, animated: true)
    }
    
    
    func changeIndicatorColour(){
        if countOfTappedPIN < 0{
            countOfTappedPIN = 0
        }
        if countOfTappedPIN > 0{
            fillViewOne.backgroundColor = .systemGreen
            if countOfTappedPIN > 1 {
                fillViewTwo.backgroundColor = .systemGreen
                if countOfTappedPIN > 2 {
                    fillViewThree.backgroundColor = .systemGreen
                    if countOfTappedPIN > 3 {
                        fillViewFour.backgroundColor = .systemGreen
                        initialAlignments()
                        countOfTappedPIN = 0
                        switch PINState {
                        case .Check:
                            verifySamePassword()
                        case .Update:
                            toAllowGiveEnterSecondPIN()
                        }
                        
                    }
                }
            }
        }
    }
    
    
    func updatePassword(){
        var arrToStr:String = ""
        for i in 0...password.count-1 {
            arrToStr += password[i]
        }
        
        UserDefaults.standard.set(arrToStr, forKey: Constants.PIN)
    }
    
    func verifySamePassword(){
        var arrToStr:String = ""
        for i in 0...password.count-1 {
            arrToStr += password[i]
        }
        if arrToStr == UserDefaults.standard.string(forKey: Constants.PIN) {
            DispatchQueue.main.async { [self] in
                isUnlock?(true)
            }
        } else {
            let alert = UIAlertController(title: "Wrong password", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Back", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        password = []
    }
    
    
    func checkPasswordForUpdate() -> Bool{
        if password == confirmPassword {
            var arrToStr:String = ""
            for i in 0...confirmPassword.count-1 {
                arrToStr += confirmPassword[i]
            }
            print(arrToStr)
            
            UserDefaults.standard.set(arrToStr, forKey: Constants.PIN)
            return true
        } else {
            let alert = UIAlertController(title: "Please enter two same password", message: "Your password is wrong", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default,handler: nil)
            alert.addAction(action)
            password.removeAll()
            confirmPassword.removeAll()
            attemptOfPINChageOperation = 1
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
    }
    
    
    func toAllowGiveEnterSecondPIN(){
        if attemptOfPINChageOperation == 2 {
            let toAllow = checkPasswordForUpdate()
            if toAllow{
                let alert = UIAlertController(title: "Youe PIN update succesfully", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Done", style: .default) { action in
                    UserDefaults.standard.set(true, forKey: Constants.PasswordExists)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            attemptOfPINChageOperation = 1
            }
            
            
            
        } else {
            let alert = UIAlertController(title: "Please confirm your PIN again", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            attemptOfPINChageOperation = 2
        }
    }
    
    
    @IBAction func numericBtnsTapped(_ sender: UIButton) {
        countOfTappedPIN += 1
        if let n = sender.titleLabel?.text{
            if attemptOfPINChageOperation == 1 {
                password.append(n)
            } else if attemptOfPINChageOperation == 2 {
                confirmPassword.append(n)
            }
            changeIndicatorColour()
        }
    }
    @IBAction func dltBtnTapped(_ sender: UIButton) {
        countOfTappedPIN -= 1
        if countOfTappedPIN >= 0 {
            if attemptOfPINChageOperation == 1 {
                password.remove(at: password.count-1)
            } else if attemptOfPINChageOperation == 2 {
                confirmPassword.remove(at: confirmPassword.count-1)
            }
        }
        initialAlignments()
        changeIndicatorColour()
    }
    


}
