//
//  PINVc.swift
//  ScreenLockDesign
//
//  Created by surya-zstk231 on 17/06/21.
//

import UIKit

class PINVc: UIViewController {

    
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
    
    @IBOutlet weak var btnHeightConstrain: NSLayoutConstraint!
    var countOfTappedPIN:Int = 0
    
    var password:[String] = []
    
    var confirmPassword:[String] = []
    
    var attemptOfPINChageOperation = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialAlignments()
        
        toCircleBtns()

    }
    
    //MARK:- func used for make circle btns
    ///UI Collapse area
    
    func toCircleBtns(){
        let btnArr:[UIButton] = [btn1,btn2,btn3,btn4,btn5,btn6,btn7,btn8,btn9,btn0,dltBtn]
        
        for i in 0...btnArr.count-1 {
            btnArr[i].layer.cornerRadius = btnHeightConstrain.constant / 2
            btnArr[i].clipsToBounds = true
            print(i)
            print(btnArr[i].frame.height)
            print(btnArr[i].frame.width)
            print("---------")
            
        }
        
    }
    
    func dissmisView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func initialAlignments(){
        let viewArr:[UIView] = [fillViewOne,fillViewTwo,fillViewThree,fillViewFour]
        
        for i in 0...viewArr.count-1{
            viewArr[i].layer.borderColor = UIColor.systemGreen.cgColor
            viewArr[i].backgroundColor = UIColor(cgColor: UIColor.white.cgColor)
            viewArr[i].layer.borderWidth = 2
            viewArr[i].layer.cornerRadius = fillViewFour.frame.height/2
        }
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
                        if attemptOfPINChageOperation == 2 {
                            checkPassword()
                            
                            print(password)
                            print(confirmPassword)
                            let alert = UIAlertController(title: "Youe PIN update succesfully", message: "", preferredStyle: .alert)
                            let action = UIAlertAction(title: "Done", style: .default) { action in
                                self.dissmisView()
                            }
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                            attemptOfPINChageOperation = 1
                            
                            
                            
                        } else {
                            let alert = UIAlertController(title: "Please confirm your PIN again", message: "", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                            
                            attemptOfPINChageOperation = 2
                        }
                        
                    }
                }
            }
        }
    }
    
    
    func checkPassword(){
        if password == confirmPassword {
            var arrToStr:String = ""
            for i in 0...confirmPassword.count-1 {
                arrToStr += confirmPassword[i]
            }
            print(arrToStr)
            
            UserDefaults.standard.set(arrToStr, forKey: "PIN")
        } else {
            let alert = UIAlertController(title: "Please enter two same password", message: "Your password is wrong", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default,handler: nil)
            alert.addAction(action)
            password.removeAll()
            confirmPassword.removeAll()
            self.present(alert, animated: true, completion: nil)
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
